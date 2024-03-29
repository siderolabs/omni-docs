---
title: "Configure Keycloak for Omni"
draft: false
weight: 220
---

1. Log in to Keycloak.

2. Create a realm.

- In the upper left corner of the page, select the dropdown where it says **master**

{{< imgproc keycloak_001.png Resize "900x" >}}
{{< /imgproc >}}

- Fill in the **realm name** and select **create**

{{< imgproc keycloak_002.png Resize "900x" >}}
{{< /imgproc >}}

3. Find the realm metadata.

- In the realm settings, there is a link to the metadata needed for SAML under Endpoints.
  - Copy the link or save the data to a file. It will be needed for the installation of Omni.

{{< imgproc keycloak_003.png Resize "900x" >}}
{{< /imgproc >}}

4. Create a client

- Select the **Clients** tab on the left

{{< imgproc keycloak_004.png Resize "900x" >}}
{{< /imgproc >}}

- Fill in the **General Settings** as shown in the example below. **Replace the hostname in the example with your own Omni hostname or IP**.
  - Client type
  - Client ID
  - Name

{{< imgproc keycloak_005.png Resize "900x" >}}
{{< /imgproc >}}

- Fill in the **Login settings** as shown in the example below. **Replace the hostname in the example with your own Omni hostname or IP**.
  - Root URL
  - Valid redirect URIs
  - Master SAML PRocessing URL

{{< imgproc keycloak_006.png Resize "900x" >}}
{{< /imgproc >}}

- Modify the **Signature and Encryption** settings.
  - Sign documents: **off**
  - Sign assertions: **on**

{{< imgproc keycloak_007.png Resize "900x" >}}
{{< /imgproc >}}

- Set the **Client signature required** value to **off**.

{{< imgproc keycloak_008.png Resize "900x" >}}
{{< /imgproc >}}

- Modify **Client Scopes**

{{< imgproc keycloak_009.png Resize "900x" >}}
{{< /imgproc >}}

- Select **Add predefined mapper**.

{{< imgproc keycloak_010.png Resize "900x" >}}
{{< /imgproc >}}

- The following mappers need to be added because they will be used by Omni will use these attributes for assigning permissions.
  - X500 email
  - X500 givenName
  - X500 surname

{{< imgproc keycloak_011.png Resize "900x" >}}
{{< /imgproc >}}

- Add a new user (optional)
  - If Keycloak is being used as an Identity Provider, users can be created here.

{{< imgproc keycloak_012.png Resize "900x" >}}
{{< /imgproc >}}

- Enter the **user information** and set the **Email verified** to **Yes**

{{< imgproc keycloak_013.png Resize "900x" >}}
{{< /imgproc >}}

- Set a password for the user.

{{< imgproc keycloak_014.png Resize "900x" >}}
{{< /imgproc >}}

