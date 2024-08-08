---
description: A guide on how to register a GCP instance with Omni.
---

# Register a GCP Instance

### Dashboard <a href="#dashboard" id="dashboard"></a>

Upon logging in you will be presented with the Omni dashboard.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-gcp-instance/1_hu0be398a1d6bb39386fc95dcd73c16f2d_294614_900x0_resize_catmullrom_3.png" alt="" height="563" width="900"><figcaption></figcaption></figure>

### Download the Image <a href="#download-the-image" id="download-the-image"></a>

First, download the GCP image from the Omni portal by clicking on the “Download Installation Media” button. Now, click on the “Options” dropdown menu and search for the “GCP” option. Notice there are two options: one for `amd64` and another for `arm64`. Select the appropriate option for the machine you are registering. Now that you have selected the GCP option for the appropriate architecture, click the “Download” button.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-gcp-instance/2_hu0be398a1d6bb39386fc95dcd73c16f2d_1218957_900x0_resize_catmullrom_3.png" alt="" height="563" width="900"><figcaption></figcaption></figure>

### Upload the Image <a href="#upload-the-image" id="upload-the-image"></a>

In the Google Cloud console, navigate to `Buckets` under the `Cloud Storage` menu, and create a new bucket with the default. Click on the bucket in the Google Cloud console, click `Upload Files`, and select the image download from the Omni console.

### Convert the Image <a href="#convert-the-image" id="convert-the-image"></a>

In the Google Cloud console select `Images` under the `Compute Engine` menu, and then `Create Image`. Name your image (e.g. Omni-talos-1.2.6), then select the Source as `Cloud Storage File`. Click `Browse` in the Cloud Storage File field and navigate to the bucket you created. Select the image you uploaded. Leave the rest of the options at their default and click `Create` at the bottom.

### Create a GCP Instance <a href="#create-a-gcp-instance" id="create-a-gcp-instance"></a>

In Google Cloud console select `VM instances` under the `Compute Engine` menu. Now select `Create Instance`. Name your instance, and select a region and zone. Under “Machine Configuration”, ensure your instance has at least 4GB of memory. In the `Boot Disk` section, select `Change` and then select `Custom Images`. Select the image created in the previous steps. Now, click `Create` at the bottom to create your instance.

### Conclusion <a href="#conclusion" id="conclusion"></a>

Navigate to the “Machines” menu in the sidebar. You should now see a machine listed.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-gcp-instance/3_hub2723a3bce83670dc2756e84b1b5c70c_291403_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

You now have a GCP machine registered with Omni and ready to provision.

\
