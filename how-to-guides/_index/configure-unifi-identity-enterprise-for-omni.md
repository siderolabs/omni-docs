---
description: How to configure Unifi Identity Enterprise for Omni using SAML.
---

# Configure Unifi Identity Enterprise for Omni

### Unifi Identity Enterprise <a href="#unifi-identity-enterprise" id="unifi-identity-enterprise"></a>

This section describes how to use Unifi Identity Enterprise (here forward UIIE) SSO with Omni via SAML

First, login to the UIIE Manager portal and navigate to the SSO Apps section in the left menu.

Next, Add a new app. Choose “Add Custom App”

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/saml-and-omni/how-to-configure-uiie-for-omni/001_hube88d041c8722ff5870e1a557ef7f5fb_20291_700x0_resize_catmullrom_3.png" alt="" height="217" width="700"><figcaption></figcaption></figure>

Next, click Add on the “SAML 2.0” option for Sign-on Method

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/saml-and-omni/how-to-configure-uiie-for-omni/002_hu40d8958b6353cdf71550173f3bdedd66_36379_700x0_resize_catmullrom_3.png" alt="" height="218" width="700"><figcaption></figcaption></figure>

You’ll now be in the Add SAML 2.0 App screen where we’ll define the app.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/saml-and-omni/how-to-configure-uiie-for-omni/003_hu1df4c52570a243c2222fd1d15fa9a41e_52043_700x0_resize_catmullrom_3.png" alt="" height="711" width="700"><figcaption></figcaption></figure>

| Option                      | Value                                  | Description                                                             |
| --------------------------- | -------------------------------------- | ----------------------------------------------------------------------- |
| Name                        | Omni                                   | A descriptive name for the Web App                                      |
| Icon                        | \<your choice>                         | Upload an icon of your choosing                                         |
| Single Sign-On URL          | https://\<fqdn for omni>/saml/acs      | The fully-qualified domain name at which your omni instance will reside |
| Audience URI (SP Entity ID) | https://\<fqdn for omni>/saml/metadata | The fully-qualified domain name for metadata retrieval                  |
| Default Relay State         |                                        | Leave this blank                                                        |
| Name ID Format              | Unspecified                            | Unspecified works, you can probably also choose emailAddress            |
| App Username                | Email                                  | Works best with emails as usernames however prefixes might work too     |
| SCIM Connection             | Off                                    | Not used                                                                |

After entering the above values and clicking the “Add” button, you’ll be taken to another screen with some details. We don’t need anything from here, we’ll get info we need later after further configuration, so just click “Done” to proceed.

You’ll now be on the screen to manage the app, here you’ll want to assign users/groups according to who you would like to have the ability to login to Omni. To start with, you probably only want to assign the person who will be the primary admin, as the first user to login will be granted that role in Omni. Therefore, best practice would be to assign your primary admin, have them login to Omni, then come back into the app here and assign any other users who should have access.

Once you’ve assigned the user(s) accordingly, click the “Settings” bubble at the top of the screen as some final configuration is needed here.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/saml-and-omni/how-to-configure-uiie-for-omni/004_hu46f83771c0b601857c193ca0a5028f8e_4547_300x0_resize_catmullrom_3.png" alt="" height="57" width="300"><figcaption></figcaption></figure>

Expand the “Sign On” section at the bottom of the settings page via the “Show More” down arrow.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/saml-and-omni/how-to-configure-uiie-for-omni/005_hue8664a600bc11a2201622be11020c424_3607_700x0_resize_catmullrom_3.png" alt="" height="64" width="700"><figcaption></figcaption></figure>

At the bottom of this section, you’ll see an “Attibute Statements” block, here the mappings from UIIE to Omni fields needs to be entered as below. Use the “Add Another” button to create new ones.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/saml-and-omni/how-to-configure-uiie-for-omni/006_hu3b220caa2fc90e79d17bded94497ce18_14816_700x0_resize_catmullrom_3.png" alt="" height="158" width="700"><figcaption></figcaption></figure>

| Name      | Name Format | Value      | Description              |
| --------- | ----------- | ---------- | ------------------------ |
| email     | Unspecified | Email      | The user’s email address |
| firstName | Unspecified | First Name | The user’s first name    |
| lastName  | Unspecified | Last Name  | The user’s last name     |

Lastly, you’ll need the IDP Metadata file which can be obtained via the View Setup Instructions link or downloaded as an xml file via the Identity Provider metadata link; both of which are slightly further up the page.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/saml-and-omni/how-to-configure-uiie-for-omni/007_hufc071bbd2302f90af4e9922640382f19_19488_700x0_resize_catmullrom_3.png" alt="" height="146" width="700"><figcaption></figcaption></figure>

A copy of this file needs to be on the host which will run the Omni container as we’ll feed it in to the container at runtime. You can copy paste contents or download/upload the file whichever is easiest. For the remainder of this guide, we’ll assume this file ends up at the following location on your container host: `~/uiieIDPmetadata.xml`

This completes the configurations required in UIIE

### Omni <a href="#omni" id="omni"></a>

To get Omni to use UIIE as a SAML provider, the following flags should be passed to Docker & the Omni container on launch.

| Scope  | Flag                                               | Description                                       |
| ------ | -------------------------------------------------- | ------------------------------------------------- |
| Docker | `-v $PWD/uiieIDPmetadata.xml:/uiieIDPmetadata.xml` | Make available the IDP metadata file in container |
| Omni   | `--auth-saml-enabled=true`                         | Enable SAML authentication.                       |
| Omni   | `--auth-saml-metadata-/uiieIDPmetadata.xml`        | The path to the IDP metadata file.                |

For example;

Copy

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
