#!/usr/bin/env pwsh

$diskConfig = New-AzDiskConfig `
-Location $location `
-CreateOption Empty `
-DiskSizeGB 32 `
-Sku Standard_LRS

$diskName = 'az104-03c-disk1'

New-AzDisk `
-ResourceGroupName $rgName `
-DiskName $diskName `
-Disk $diskConfig
