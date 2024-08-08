# Configure Keycloak for Omni

1. Log in to Keycloak.
2. Create a realm.

* In the upper left corner of the page, select the dropdown where it says **master**

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_001_hua2304d9252cda464b024eda64076dce5_225546_900x0_resize_catmullrom_3.png" alt="" height="335" width="900"><figcaption></figcaption></figure>

* Fill in the **realm name** and select **create**

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_002_hu219c301b3cc1d92a219053b75dc88f38_109895_900x0_resize_catmullrom_3.png" alt="" height="333" width="900"><figcaption></figcaption></figure>

3. Find the realm metadata.

* In the realm settings, there is a link to the metadata needed for SAML under Endpoints.
  * Copy the link or save the data to a file. It will be needed for the installation of Omni.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_003_hub14b2bc17ac2112368eada972453eeae_193727_900x0_resize_catmullrom_3.png" alt="" height="396" width="900"><figcaption></figcaption></figure>

4. Create a client

* Select the **Clients** tab on the left

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_004_hub24bb8d434c48c5ecdee815ab3b0a24a_230667_900x0_resize_catmullrom_3.png" alt="" height="333" width="900"><figcaption></figcaption></figure>

* Fill in the **General Settings** as shown in the example below. **Replace the hostname in the example with your own Omni hostname or IP**.
  * Client type
  * Client ID
  * Name

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_005_hu4770cde6c0e74bc6a3f616372d5527e2_141496_900x0_resize_catmullrom_3.png" alt="" height="338" width="900"><figcaption></figcaption></figure>

* Fill in the **Login settings** as shown in the example below. **Replace the hostname in the example with your own Omni hostname or IP**.
  * Root URL
  * Valid redirect URIs
  * Master SAML PRocessing URL

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_006_hu0e57ccdbe43392bd1d5a7b083d37b412_192764_900x0_resize_catmullrom_3.png" alt="" height="429" width="900"><figcaption></figcaption></figure>

* Modify the **Signature and Encryption** settings.
  * Sign documents: **off**
  * Sign assertions: **on**

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_007_hu2af18db5a66f75c4d7147a4fd012cad8_162247_900x0_resize_catmullrom_3.png" alt="" height="448" width="900"><figcaption></figcaption></figure>

* Set the **Client signature required** value to **off**.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_008_hu9b1174c3819727f971d4d58e27411672_207789_900x0_resize_catmullrom_3.png" alt="" height="378" width="900"><figcaption></figcaption></figure>

* Modify **Client Scopes**

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_009_hu33b63e4eea9519dad2e8204a04b69afd_160374_900x0_resize_catmullrom_3.png" alt="" height="314" width="900"><figcaption></figcaption></figure>

* Select **Add predefined mapper**.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_010_hu88b27b362ea4ec499b5958cadefb449b_126513_900x0_resize_catmullrom_3.png" alt="" height="300" width="900"><figcaption></figcaption></figure>

* The following mappers need to be added because they will be used by Omni will use these attributes for assigning permissions.
  * X500 email
  * X500 givenName
  * X500 surname

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_011_hu49e0e2e139c0df4d8d9e7f75eb524b4a_171107_900x0_resize_catmullrom_3.png" alt="" height="383" width="900"><figcaption></figcaption></figure>

* Add a new user (optional)
  * If Keycloak is being used as an Identity Provider, users can be created here.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_012_hu7c7a03fde0b816d8544bc524416a7e07_84646_900x0_resize_catmullrom_3.png" alt="" height="298" width="900"><figcaption></figcaption></figure>

* Enter the **user information** and set the **Email verified** to **Yes**

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_013_huad06caab3957a6f8d2f6bd1eae3df0fe_110131_900x0_resize_catmullrom_3.png" alt="" height="318" width="900"><figcaption></figcaption></figure>

* Set a password for the user.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/self-hosted/how-to-configure-keycloak-for-omni/keycloak_014_hu654d7e325e70b5925b5161e77ad53991_114695_900x0_resize_catmullrom_3.png" alt="" height="301" width="900"><figcaption></figcaption></figure>

***
