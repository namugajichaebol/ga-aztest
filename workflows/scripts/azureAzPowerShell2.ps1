#!/usr/bin/env pwsh

$rgName = 'az104-03c-rg1'
$location = 'eastus'

Get-AzResourceGroup -Name $rgName
