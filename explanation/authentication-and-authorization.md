# Authentication and Authorization

### Auth0

#### Github

In order to login with GitHub you must use your primary verified email.

### SAML

Security Assertion Markup Language (SAML) is an open standard that allows identity providers (IdP) to pass authorization credentials to service providers (SP). Omni plays the role of service provider.

To enable SAML on your account please submit a ticket in [Zendesk](https://sidero.zendesk.com/). Or reach out to us in the #omni channel in [Slack](https://slack.dev.talos-systems.io/).

SAML alters Omni user management:

* Users are automatically created on the first login into Omni:
* the first user gets `Admin` role;
* any subsequently created user gets `None` role.
* `Admin` can change other users' roles.
* Creating or deleting a user is not possible from within Omni - only within the IdP.
* Omni gets the user attributes from the SAML assertion and adds them as labels to `Identity` resource with `saml.omni.sidero.dev/` prefix.
* ACL can be used to adjust fine grained permissions instead of changing the user roles.
