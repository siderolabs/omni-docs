---
title: Configure Unifi Identity Enterprise for Omni
description: "How to configure Unifi Identity Enterprise for Omni using SAML."
draft: false
weight: 230
aliases:
  - ../how-to-configure-uiie-for-omni/
---

## Unifi Identity Enterprise

This section describes how to use Unifi Identity Enterprise (here forward UIIE) SSO with Omni via SAML

First, login to the UIIE Manager portal and navigate to the SSO Apps section in the left menu.

Next, Add a new app. Choose "Add Custom App"

{{< imgproc 001.png Resize "700x" >}}
{{< /imgproc >}}

Next, click Add on the "SAML 2.0" option for Sign-on Method

{{< imgproc 002.png Resize "700x" >}}
{{< /imgproc >}}

You'll now be in the Add SAML 2.0 App screen where we'll define the app.

{{< imgproc 003.png Resize "700x" >}}
{{< /imgproc >}}

| Option                      | Value                                   | Description                                                             |
| :-------------------------- | :------------------------------------   | :---------------------------------------------------------------------- |
| Name                        | Omni                                    | A descriptive name for the Web App                                      |
| Icon                        | \<your choice\>                         | Upload an icon of your choosing                                         |
| Single Sign-On URL          | https://\<fqdn for omni\>/saml/acs      | The fully-qualified domain name at which your omni instance will reside |
| Audience URI (SP Entity ID) | https://\<fqdn for omni\>/saml/metadata | The fully-qualified domain name for metadata retrieval                  |
| Default Relay State         |                                         | Leave this blank                                                        |
| Name ID Format              | Unspecified                             | Unspecified works, you can probably also choose emailAddress            |
| App Username                | Email                                   | Works best with emails as usernames however prefixes might work too     | 
| SCIM Connection             | Off                                     | Not used                                                                |

After entering the above values and clicking the "Add" button, you'll be taken to another screen with some details. We don't need anything from here, we'll get info we need later after further configuration, so just click "Done" to proceed.

You'll now be on the screen to manage the app, here you'll want to assign users/groups according to who you would like to have the ability to login to Omni.
To start with, you probably only want to assign the person who will be the primary admin, as the first user to login will be granted that role in Omni. Therefore, best practice would be to assign your primary admin, have them login to Omni, then come back into the app here and assign any other users who should have access.

Once you've assigned the user(s) accordingly, click the "Settings" bubble at the top of the screen as some final configuration is needed here.

{{< imgproc 004.png Resize "300x" >}}
{{< /imgproc >}}

Expand the "Sign On" section at the bottom of the settings page via the "Show More" down arrow.

{{< imgproc 005.png Resize "700x" >}}
{{< /imgproc >}}

At the bottom of this section, you'll see an "Attibute Statements" block, here the mappings from UIIE to Omni fields needs to be entered as below. Use the "Add Another" button to create new ones.

{{< imgproc 006.png Resize "700x" >}}
{{< /imgproc >}}

| Name      | Name Format | Value      | Description              |
| :-------- | :---------- | :--------- | :----------------------- |
| email     | Unspecified | Email      | The user's email address |
| firstName | Unspecified | First Name | The user's first name    |
| lastName  | Unspecified | Last Name  | The user's last name     |

Lastly, you'll need the IDP Metadata file which can be obtained via the View Setup Instructions link or downloaded as an xml file via the Identity Provider metadata link; both of which are slightly further up the page. 

{{< imgproc 007.png Resize "700x" >}}
{{< /imgproc >}}

A copy of this file needs to be on the host which will run the Omni container as we'll feed it in to the container at runtime. You can copy paste contents or download/upload the file whichever is easiest. For the remainder of this guide, we'll assume this file ends up at the following location on your container host: `~/uiieIDPmetadata.xml`

This completes the configurations required in UIIE

## Omni

To get Omni to use UIIE as a SAML provider, the following flags should be passed to Docker & the Omni container on launch.

| Scope  | Flag                                               | Description                                             |
| :------| :------------------------------------------------- | :------------------------------------------------------ |
| Docker | `-v $PWD/uiieIDPmetadata.xml:/uiieIDPmetadata.xml` | Make available the IDP metadata file in container       |
| Omni   | `--auth-saml-enabled=true`                         | Enable SAML authentication.                             |
| Omni   | `--auth-saml-metadata-/uiieIDPmetadata.xml`        | The path to the IDP metadata file.                      |

For example;

```bash
docker run \
...
-v $PWD/uiieIDPmetadata.xml:/uiieIDPmetadata.xml
...
ghcr.io/siderolabs/omni:latest \
  --auth-saml-enabled=true
  --auth-saml-metadata-/uiieIDPmetadata.xml
```

Unfortunately UIIE does not expose group attributes, so you will have to manually assign Omni groups/roles to the users as they are created on first login.