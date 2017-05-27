### Slides
* [SlideShare](https://www.slideshare.net/AndrewCrabb4/turku2017-recentdevelopments)

### Software mentioned in the talk

* [dcm4che3](https://dcm4che.atlassian.net/wiki/display/lib/) - DICOM library and utilities
* [gdcm](https://sourceforge.net/projects/gdcm/) - DICOM library
* [dcmtk](http://dicom.offis.de/dcmtk.php.en) - DICOM toolkit
* [OsiriX](http://www.osirix-viewer.com) - Mac imaging workstation
* [Horos](https://www.horosproject.org) - Clone of OsiriX
* [89 DICOM viewers for Windows](https://idoimaging.com/programs?utf8=✓&q%5Bfunction%5D=15&q%5Bread_format%5D=3&q%5Bplatform%5D=7&q%5Bname_cont%5D=) - Knock yourself out
* [VINCI](http://www.nf.mpg.de/vinci3/) - Advanced workstation
* [Slicer3D](https://www.slicer.org) - Image analysis and visualisation
* [occiput.io](http://occiput.mgh.harvard.edu) - GPU-based 2D-4D PET/SPECT reconstruction
* [NiftyRec](http://niftyrec.scienceontheweb.net/wordpress/) - Tomography toolbox for GPU computing
* [DCM4CHEE Archive Light](https://github.com/dcm4che/dcm4chee-arc-light/wiki) - Modern PACS server
* [Orthanc](http://www.orthanc-server.com/static.php?page=about) - Lightweight DICOM server
* [DWV](https://github.com/ivmartel/dwv/wiki) - Dicom Web Viewer
* [Papaya, Daikon, Mango](http://rii.uthscsa.edu/mango/index.html) - Univ. Texas Health Science Center
* Papaya: [Home](http://rii.uthscsa.edu/mango/papaya.html), [GitHub](http://rii-mango.github.io/Papaya/) - Univ. Texas Health Science Center
* [Stone of Orthanc](http://www.orthanc-server.com/static.php?page=stone) - CPU-based rendering
* [Weasis](https://dcm4che.atlassian.net/wiki/display/WEA/Home) - Java DICOM viewer

### Live demonstrations

* [Orthanc Web Explorer](http://demo.orthanc-server.com/app/explorer.html)
* [Orthanc Parsing DICOM using WebAssembly](http://www.orthanc-server.com/external/wasm-dicom-parser/)
* [DWV Web Viewer](https://ivmartel.github.io/dwv/) - Yves Martel
* [Orthanc plugins: Orthanc Web Viewer and DWV Viewer](http://pacs.idoimaging.com:8042/app/explorer.html#series?uuid=871837ba-121a572b-a87110a3-b2910bd9-d5765cd0) - I Do Imaging (login 'orthanc'/'orthanc')
* [OHIF Viewer](http://viewer.ohif.org)
* [dicomParser](https://rawgit.com/chafey/dicomParser/master/examples/index.html) Drag and drop DICOM file for header dump
* [Osimis Web Viewer](http://osimisviewer.osimis.io/) - Embedded in Orthanc Explorer
* [Osimis Web Viewer](http://osimisviewer.osimis.io/osimis-viewer/app/index.html?study=1b4c72ad-5aba2557-9fc396b3-323e190c-07d36585) - Standalone
* [Papaya Research Imaging Viewer](http://rii.uthscsa.edu/mango/papaya/) - Univ. Texas Health Science Center
* [DicomParser](https://rawgit.com/chafey/dicomParser/master/examples/index.html) - Chris Hafey
* [Cornerstone](https://rawgit.com/chafey/cornerstone/master/example/index.html) - Chris Hafey

### Sample data for use with demos

* Brain MR sequence: [DICOM](https://data.idoimaging.com/dicom/1060_head_brain/1060_head_brain_lee.zip), [NIFTI](https://data.idoimaging.com/nifti/1010_brain_mr_04.nii.gz) - from I Do Imaging [sample data](https://wiki.idoimaging.com/index.php?title=Sample_Data)

### Programming languages chart

* Interactive comparison [Stack Overflow](https://insights.stackoverflow.com/trends?utm_source=so-owned&utm_medium=blog&utm_campaign=trends&utm_content=blog-link&tags=java%2Cjavascript%2Cc%2Cc%2B%2B%2Cpython%2Cc%23)

### DICOMweb links

Login: `demo`, Password: `demo`

* List all patients: [http://pacs.idoimaging.com:8042/patients](http://pacs.idoimaging.com:8042/patients)

Note: The following displayed URLs are shortened.  They all start with `http://pacs.idoimaging.com:8042/` and the ID is shortened to the last 8 characters.  The full URL is shown in your browser address bar.

* Details of first patient: [/patients/dca39290](http://pacs.idoimaging.com:8042/patients/1966e694-bad90686-516f99cd-f432800f-dca39290)
* Studies of first patient: [/patients/dca39290/studies](http://pacs.idoimaging.com:8042/patients/1966e694-bad90686-516f99cd-f432800f-dca39290/studies)
* First series of patient's study: [/series/d5765cd0](http://pacs.idoimaging.com:8042/series/871837ba-121a572b-a87110a3-b2910bd9-d5765cd0)
* Sample Python program: [list_patients.py](https://data.idoimaging.com/bin/list_patients.py)


