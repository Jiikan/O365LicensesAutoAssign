# O365 Licenses Auto Assign
Automatically assigns O365 licenses for a list of users in a CSV file.

The command first connects to the Microsoft Online Services and assigns the O365 plan SKU into a variable (Office 365 E3, Azure Active Directory Premium P1, etc)

Then, the services within each plan SKU are then put into their own variables. The services are specified with the -DisabledPlans parameter - any service not listed here will be enabled.

A ForEach loop is run against a CSV file which contains the UPN of your users. It also sets the location of the user to the United States (You can set the location code for your own country). This is mandatory for new users and you are unable to assign licenses until this is set.
