# Beeplay iOS

## Project setup

Download the project

    $ git clone [project] .

Download Cocoa Pods and install them on your computer from [http://www.cocoapods.org/](http://www.cocoapods.org/).

Then from the project **/beeplay-ios** folder (where there is the **Podfile**), run the following command:

    $ pod install

This will download and reference all the external libraries used by the Beeplay project.

Now you can open the project using the **Beeplay.xcworkspace**

---

The project has multiple schemes for the different releases as explained in this post http://swwritings.com/post/2013-05-20-concurrent-debug-beta-app-store-builds

These different builds require the following Distribution Profiles:

*	Alpha - com.beeplay.beeplayapp.adhoc - is intended to use for internal testing and uses the Beeplay Mobile Internal profile
*	Beta - com.beeplay.beeplayapp.test - is intended to use for testing with the beta testers and uses the Beeplay Mobile Test profile
*	Release - com.beeplay.beeplayapp - is intended for App Store release and uses the Beeplay App Store Profile