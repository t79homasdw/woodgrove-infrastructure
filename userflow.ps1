$body = @{
    "@odata.type" = "#microsoft.graph.externalUsersSelfServiceSignUpEventsFlow"
    displayName   = "3Cloud-CIAM-Demo"
    description   = "Self-service sign-up for external users"
    conditions    = @{
        applications = @{
            includeApplications = @(@{ id = "<AppId>" })
        }
    }
    onInteractiveAuthFlowStart = @{
        "@odata.type" = "#microsoft.graph.onInteractiveAuthFlowStartExternalUsersSelfServiceSignUp"
        isSignUpAllowed = $true
        identityProviders = @(@{ id = "Email" })
    }
    onAuthenticationMethodLoadStart = @{
        "@odata.type" = "#microsoft.graph.onAuthenticationMethodLoadStartExternalUsersSelfServiceSignUp"
        identityProviders = @(
            @{
                "@odata.type" = "#microsoft.graph.builtInIdentityProvider"
                id = "EmailOtpSignup-OAUTH"
                displayName = "Email One Time Passcode"
                supportedTenantTypes = "externalId"
                identityProviderType = "EmailOTP"
            }
        )
    }
    onAttributeCollection = @{
        "@odata.type" = "#microsoft.graph.onAttributeCollectionExternalUsersSelfServiceSignUp"
        accessPackages = @()
        attributeCollectionPage = @(
            @{
                views = @(
                    @{
                        inputs = @(
                            @{ attribute = "email"; label = "Email Address"; inputType = "text"; hidden = $true; editable = $false; writeToDirectory = $true; required = $true; validationRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$"; options = @() },
                            @{ attribute = "country"; label = "Country/Region"; inputType = "text"; hidden = $false; editable = $true; writeToDirectory = $true; required = $true; validationRegEx = "^.*"; options = @() }
                            # Add other attributes here...
                        )
                    }
                )
            }
        )
        attributes = @(
            @{ id = "email"; displayName = "Email Address"; description = "Email address of the user"; userFlowAttributeType = "builtIn"; dataType = "string"; supportedTenantTypes = "externalId" },
            @{ id = "country"; displayName = "Country/Region"; description = "The country/region in which the user is located."; userFlowAttributeType = "builtIn"; dataType = "string"; supportedTenantTypes = "externalId" }
            # Add other attributes here...
        )
    }
    onUserCreateStart = @{
        "@odata.type" = "#microsoft.graph.onUserCreateStartExternalUsersSelfServiceSignUp"
        userTypeToCreate = "member"
        accessPackages = @()
    }
} | ConvertTo-Json -Depth 10

Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/identity/authenticationEventFlows" -Body $body -ContentType "application/json"
