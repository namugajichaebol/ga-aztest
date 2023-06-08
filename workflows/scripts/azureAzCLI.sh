#!/usr/bin/env bash

az group list
az deployment group list --resource-group $1
