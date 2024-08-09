# Configure Keycloak for Omni

1. Log in to Keycloak.
2. Create a realm.

* In the upper left corner of the page, select the dropdown where it says **master**

<figure><img src="../../.gitbook/assets/keycloak_001.png" alt=""><figcaption></figcaption></figure>

* Fill in the **realm name** and select **create**

<figure><img src="../../.gitbook/assets/keycloak_002.png" alt=""><figcaption></figcaption></figure>

3. Find the realm metadata.

* In the realm settings, there is a link to the metadata needed for SAML under Endpoints.
  * Copy the link or save the data to a file. It will be needed for the installation of Omni.

<figure><img src="../../.gitbook/assets/keycloak_003.png" alt=""><figcaption></figcaption></figure>

4. Create a client

* Select the **Clients** tab on the left

<figure><img src="../../.gitbook/assets/keycloak_004.png" alt=""><figcaption></figcaption></figure>

* Fill in the **General Settings** as shown in the example below. **Replace the hostname in the example with your own Omni hostname or IP**.
  * Client type
  * Client ID
  * Name

<figure><img src="../../.gitbook/assets/keycloak_005.png" alt=""><figcaption></figcaption></figure>

* Fill in the **Login settings** as shown in the example below. **Replace the hostname in the example with your own Omni hostname or IP**.
  * Root URL
  * Valid redirect URIs
  * Master SAML Processing URL

<figure><img src="../../.gitbook/assets/keycloak_006.png" alt=""><figcaption></figcaption></figure>

* Modify the **Signature and Encryption** settings.
  * Sign documents: **off**
  * Sign assertions: **on**

<figure><img src="../../.gitbook/assets/keycloak_007.png" alt=""><figcaption></figcaption></figure>

* Set the **Client signature required** value to **off**.

<figure><img src="../../.gitbook/assets/keycloak_008.png" alt=""><figcaption></figcaption></figure>

* Modify **Client Scopes**

<figure><img src="../../.gitbook/assets/keycloak_009.png" alt=""><figcaption></figcaption></figure>

* Select **Add predefined mapper**.

<figure><img src="../../.gitbook/assets/keycloak_010.png" alt=""><figcaption></figcaption></figure>

* The following mappers need to be added because they will be used by Omni will use these attributes for assigning permissions.
  * X500 email
  * X500 givenName
  * X500 surname

<figure><img src="../../.gitbook/assets/keycloak_011.png" alt=""><figcaption></figcaption></figure>

* Add a new user (optional)
  * If Keycloak is being used as an Identity Provider, users can be created here.

<figure><img src="../../.gitbook/assets/keycloak_012.png" alt=""><figcaption></figcaption></figure>

* Enter the **user information** and set the **Email verified** to **Yes**

<figure><img src="../../.gitbook/assets/keycloak_013.png" alt=""><figcaption></figcaption></figure>

* Set a password for the user.

<figure><img src="../../.gitbook/assets/keycloak_014.png" alt=""><figcaption></figcaption></figure>

***
