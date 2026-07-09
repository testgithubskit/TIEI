#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Main Module for the Monitoring Application
===============================================

Module for starting point of the FastApi application

This script requires the following modules be installed in the python environment
    * logging - To perform logging operations.
    * fastapi - To perform web application (backend) related functions.
"""

# Standard library imports
import logging

# Related third party imports
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Local application/library specific imports
from machine_monitoring_app.utils.configuration_helper import initialize_server
from machine_monitoring_app.routers import core_data_route, security_routes, front_end_utility_route, base_routers, email_user_routes

#from machine_monitoring_app.database.db_utils import connect_to_mongo, close_mongo_connection


__author__ = "smt18m005@iiitdm.ac.in"

LOGGER = logging.getLogger(__name__)

APP = FastAPI()

# Private / local network frontends (different host, IP, or port than the API).
# Browsers require explicit origins when credentials are sent — "*" is not allowed.
ALLOWED_ORIGIN_REGEX = (
    r"https?://"
    r"(localhost|127\.0\.0\.1"
    r"|172\.\d{1,3}\.\d{1,3}\.\d{1,3}"
    r"|10\.\d{1,3}\.\d{1,3}\.\d{1,3}"
    r"|192\.168\.\d{1,3}\.\d{1,3}\.\d{1,3}"
    r"|maintenance\.cmti\.online)"
    r"(:\d+)?"
)

APP.add_middleware(
    CORSMiddleware,
    allow_origins=[],
    allow_origin_regex=ALLOWED_ORIGIN_REGEX,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)

APP.add_event_handler("startup", initialize_server)
#APP.add_event_handler("shutdown", close_mongo_connection)

APP.include_router(core_data_route.ROUTER)
APP.include_router(security_routes.ROUTER)
APP.include_router(front_end_utility_route.ROUTER)
APP.include_router(base_routers.ROUTER)
APP.include_router(email_user_routes.ROUTER)

LOGGER.info("Starting Application")

# For backend
# uvicorn main:APP --reload --host 172.18.101.47 --port 6699
# uvicorn main:APP --reload --host 192.168.217.61 --port 7788
# uvicorn main:APP --reload --host 172.18.7.27 --port 6699
# uvicorn main:APP --reload --host 10.82.125.119 --port 6699
# uvicorn main:APP --reload --host 10.82.125.119 --port 8877


# For front end
# npm run start
# npm run build
# From folder d:test_program\toyota\data_map
