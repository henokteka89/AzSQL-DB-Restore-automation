# Breaking it 
################################################ 1 ##########################################################
# 1 Connect to your Azure account
Connect-AzAccount


# 1 Set the necessary variables  
$resourceGroupName = "HXXG"
$serverName = "gXXql01"
$databaseName = "adventureworksdemo"  # Original database name
$restorePointInTime = "2024-07-24 23:55:00"  # Restore point in time
$restoredDatabaseName = "adventureworksdemo_new"  # New database name
$SubscriptionId = "e8XX-f345-AASS23-t783-fxXXAZX355"
$Edition = "Standard"
$Tier1 = "S6"
$Tier0 = "S0"

# 1 Scaling up the DTU to make the restore faster (from S0 - 10 DTU to S6 - 400 DTU)
  Set-AzSqlDatabase -ResourceGroupName $resourceGroupName -DatabaseName $databaseName -ServerName $serverName -Edition $Edition -RequestedServiceObjectiveName $Tier1

# Take some break (2 minutes)
  Start-Sleep -second 120

# 1 Restore the database
Restore-AzSqlDatabase -FromPointInTimeBackup -ResourceGroupName $resourceGroupName -ServerName $serverName -TargetDatabaseName $restoredDatabaseName -PointInTime $restorePointInTime -ResourceId "/subscriptions/$SubscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Sql/servers/$serverName/databases/$databaseName"

# Take some break (10 minutes)
#Start-Sleep -second 600


######### Wait until 1 finishes then go to 2
 
  
 
$databaseName1 = "adventureworksdemo"  # Original database name
 $restoredDatabaseName1 = "adventureworksdemo_new"  # New database name
 $Edition = "Standard"
$Tier1 = "S6"
$Tier0 = "S0"

################################################# 2 ###################################################
# Renaming the original 
Set-AzSqlDatabase -DatabaseName $databaseName1 -NewName $restoredDatabaseName1 -ServerName $serverName -ResourceGroupName $resourceGroupName

# Renaming the New to have no suffix 
Set-AzSqlDatabase -DatabaseName $restoredDatabaseName1 -NewName $databaseName1 -ServerName $serverName -ResourceGroupName $resourceGroupName

# Scaling down after finishing the task (to S0 - 10 DTU;)  ---takes 2 to 3 minutes for small DB
 Set-AzSqlDatabase -ResourceGroupName $resourceGroupName -DatabaseName $databaseName1 -ServerName $serverName -Edition $Edition -RequestedServiceObjectiveName $Tier0

##### after this is done go to 3 --- the delete part



################### 3 final ##############
#Remove the Original (Put the right name)
Remove-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName  -DatabaseName $databaseName1