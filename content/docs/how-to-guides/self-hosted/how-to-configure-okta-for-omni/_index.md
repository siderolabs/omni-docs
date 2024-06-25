---
title: "Configure Okta for Omni"
draft: false
weight: 240
aliases:
  - ../how-to-configure-okta-for-omni/

---

1. Log in to Otka
2. Create a new App Integration
3. Select "SAML 2.0"
4. Give the Application a recognisable name (we suggest simply "Omni")
5. Set the SAML Settings and Attribute Statements as show below:

{{< imgproc okta_create_saml_app.png Resize "600x" >}}
{{< /imgproc >}}

6. Click "Next" and optionally fill out the Feedback, then click "Finish"

Once that is complete, you should now be able to open the "Assignements" tab for the application you just created and manage your users and access as usual.
