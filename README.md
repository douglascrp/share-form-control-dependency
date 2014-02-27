share-form-control-dependency
=============================

This is a fork of the project https://code.google.com/p/share-form-control-dependency

What the project is:

The basic idea is to have specific form controls for Alfresco Share aware of the convention used to configure in our content model those dependencies by convention on their value syntax, and also have those generic form controls empowered though client javascript to update the corresponding form controls according to the updates made by the user on the associated properties.

It's not my original work, so all the credits go to Rui Fernandes, the project creator.

Rui presents his project in this blog post http://blogs.alfresco.com/wp/rfernandes/2012/02/06/form-control-dependency-in-alfresco-share/

My changes
==========

I've made some changes to the source code in order to have the Alfresco Data Dictionary localization working.
I've also fixed some problems related with accented characteres.
