# Configure Entra ID AD for Omni

In the Azure portal, click "Enterprise Applications".

Click "New Application" and search for "Entra SAML Toolkit".

Name this application something more meaningful if desired and click "Create".

Under the "Manage" section of the application, select "Single sign-on", then "SAML" as the single sign-on method.

In section 1 of this form, enter identifier, reply, and sign on URLs that match the following and save:

* Identifier (Entity ID): `https://<domain name for omni>/saml/metadata`
* Reply URL (Assertion Consumer Service URL): `https://<domain name for omni>/saml/acs`
* Sign on URL: `https://<domain name for omni>/login`

From section 3, copy the "App Federation Metadata Url" for later use.

Again, under the "Manage" section of the application, select "Users and groups".

Add any users or groups you wish to give access to your Omni environment here.
