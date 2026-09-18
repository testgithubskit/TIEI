#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
EMAIL USER ROUTES
=================

Module that contains the API endpoints for email user operations.
Admin-only access for all email-user configuration endpoints.
"""

# Standard library imports
import logging

# Related third party imports
from fastapi import APIRouter, HTTPException, status, Depends
from pony.orm import db_session, commit, select, exists

# Local application/library specific imports
from machine_monitoring_app.database.pony_models import EmailUser
from machine_monitoring_app.models.request_models import EmailUserRequest, EmailUserUpdate
from machine_monitoring_app.models.base_data_models import User
from machine_monitoring_app.routers.router_dependencies import get_current_active_user

__author__ = "smt18m005@iiitdm.ac.in"

LOGGER = logging.getLogger(__name__)

ROUTER = APIRouter(
    prefix="/api/v1/email_users",
    tags=["Email Users"],
    responses={404: {"description": "Not found"}}
)


def _require_admin(current_user: User):
    if current_user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authorized, Only admin can manage email users",
            headers={"WWW-Authenticate": "Bearer"},
        )


@ROUTER.post("/", status_code=status.HTTP_201_CREATED)
async def create_email_user(
    email_user: EmailUserRequest,
    current_user: User = Depends(get_current_active_user),
):
    """Create a new email user (admin only)."""
    _require_admin(current_user)
    try:
        with db_session:
            if exists(e for e in EmailUser if e.email_id == email_user.email_id):
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Email ID already exists"
                )

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
async def get_all_email_users(current_user: User = Depends(get_current_active_user)):
    """Get all email users (admin only)."""
    _require_admin(current_user)
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
async def get_email_user_by_id(
    user_id: int,
    current_user: User = Depends(get_current_active_user),
):
    """Get email user by ID (admin only)."""
    _require_admin(current_user)
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
async def update_email_user(
    user_id: int,
    email_user_update: EmailUserUpdate,
    current_user: User = Depends(get_current_active_user),
):
    """Update email user by ID (admin only)."""
    _require_admin(current_user)
    try:
        with db_session:
            user = EmailUser.get(id=user_id)

            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Email user not found"
                )

            if email_user_update.email_id and email_user_update.email_id != user.email_id:
                if exists(e for e in EmailUser if e.email_id == email_user_update.email_id):
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail="Email ID already exists"
                    )

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
async def delete_email_user(
    user_id: int,
    current_user: User = Depends(get_current_active_user),
):
    """Delete email user by ID (admin only)."""
    _require_admin(current_user)
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
