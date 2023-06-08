#!/usr/bin/env bash

az group list
az deployment group list --resource-group "${{ env.resource_group_name }}"
