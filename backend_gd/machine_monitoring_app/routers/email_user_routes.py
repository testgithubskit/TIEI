#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
EMAIL USER ROUTES
=================

Module that contains the API endpoints for email user operations

This script requires the following modules be installed in the python environment

    Standard Library
    =================

    * logging - To perform logging operations.

    Related 3rd Party Library
    =============================

    * fastapi - To perform web application (backend) related functions.
    * pony.orm - To perform database operations using orm

This script contains the following endpoints
    * POST /api/v1/email_users - Create a new email user
    * GET /api/v1/email_users - Get all email users
    * GET /api/v1/email_users/{user_id} - Get email user by ID
    * PUT /api/v1/email_users/{user_id} - Update email user by ID
    * DELETE /api/v1/email_users/{user_id} - Delete email user by ID
"""

# Standard library imports
import logging

# Related third party imports
from fastapi import APIRouter, HTTPException, status
from pony.orm import db_session, commit, select, exists

# Local application/library specific imports
from machine_monitoring_app.database.pony_models import EmailUser
from machine_monitoring_app.models.request_models import EmailUserRequest, EmailUserUpdate

__author__ = "smt18m005@iiitdm.ac.in"

LOGGER = logging.getLogger(__name__)

ROUTER = APIRouter(
    prefix="/api/v1/email_users",
    tags=["Email Users"],
    responses={404: {"description": "Not found"}}
)


@ROUTER.post("/", status_code=status.HTTP_201_CREATED)
async def create_email_user(email_user: EmailUserRequest):
    """
    Create a new email user
    
    Parameters
    ----------
    email_user : EmailUserRequest
        The email user data to create
        
    Returns
    -------
    dict
        Success message with created user ID
    """
    try:
        with db_session:
            # Check if email already exists
            if exists(e for e in EmailUser if e.email_id == email_user.email_id):
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Email ID already exists"
                )
            
            # Create new email user
            new_user = EmailUser(
                user_name=email_user.user_name,
                email_id=email_user.email_id
            )
            commit()
            
            LOGGER.info(f"Created email user: {new_user.id}")
            
            return {
                "message": "Email user created successfully",
                "id": new_user.id,
                "user_name": new_user.user_name,
                "email_id": new_user.email_id
            }
            
    except HTTPException:
        raise
    except Exception as e:
        LOGGER.error(f"Error creating email user: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@ROUTER.get("/")
async def get_all_email_users():
    """
    Get all email users
    
    Returns
    -------
    list
        List of all email users
    """
    try:
        with db_session:
            users = select(u for u in EmailUser)[:]
            
            return [
                {
                    "id": user.id,
                    "user_name": user.user_name,
                    "email_id": user.email_id
                }
                for user in users
            ]
            
    except Exception as e:
        LOGGER.error(f"Error getting email users: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@ROUTER.get("/{user_id}")
async def get_email_user_by_id(user_id: int):
    """
    Get email user by ID
    
    Parameters
    ----------
    user_id : int
        The ID of the email user
        
    Returns
    -------
    dict
        Email user details
    """
    try:
        with db_session:
            user = EmailUser.get(id=user_id)
            
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Email user not found"
                )
            
            return {
                "id": user.id,
                "user_name": user.user_name,
                "email_id": user.email_id
            }
            
    except HTTPException:
        raise
    except Exception as e:
        LOGGER.error(f"Error getting email user {user_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@ROUTER.put("/{user_id}")
async def update_email_user(user_id: int, email_user_update: EmailUserUpdate):
    """
    Update email user by ID
    
    Parameters
    ----------
    user_id : int
        The ID of the email user to update
    email_user_update : EmailUserUpdate
        The updated email user data
        
    Returns
    -------
    dict
        Success message with updated user details
    """
    try:
        with db_session:
            user = EmailUser.get(id=user_id)
            
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Email user not found"
                )
            
            # Check if new email already exists (if email is being updated)
            if email_user_update.email_id and email_user_update.email_id != user.email_id:
                if exists(e for e in EmailUser if e.email_id == email_user_update.email_id):
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail="Email ID already exists"
                    )
            
            # Update fields if provided
            if email_user_update.user_name is not None:
                user.user_name = email_user_update.user_name
            
            if email_user_update.email_id is not None:
                user.email_id = email_user_update.email_id
            
            commit()
            
            LOGGER.info(f"Updated email user: {user_id}")
            
            return {
                "message": "Email user updated successfully",
                "id": user.id,
                "user_name": user.user_name,
                "email_id": user.email_id
            }
            
    except HTTPException:
        raise
    except Exception as e:
        LOGGER.error(f"Error updating email user {user_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@ROUTER.delete("/{user_id}")
async def delete_email_user(user_id: int):
    """
    Delete email user by ID
    
    Parameters
    ----------
    user_id : int
        The ID of the email user to delete
        
    Returns
    -------
    dict
        Success message
    """
    try:
        with db_session:
            user = EmailUser.get(id=user_id)
            
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Email user not found"
                )
            
            user.delete()
            commit()
            
            LOGGER.info(f"Deleted email user: {user_id}")
            
            return {"message": "Email user deleted successfully"}
            
    except HTTPException:
        raise
    except Exception as e:
        LOGGER.error(f"Error deleting email user {user_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )
