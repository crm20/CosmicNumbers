# CNL2.0
Cosmic Number Line New Version

# Changes:
1) Remade game from scratch to create constraints for all iPad size class so that format should be stable for all versions of iPad (might slightly vary but will not conflict)
2) Made changes to each view controllers to accommodate for ui view changes
  - Except game level 1 Tommy's location
    - Checked all variables used but wasn't able to find any differences meaning that Tommy should've remained on line. For right now, it works on iPad 7th Generation (changed static number used in calculating Tommy's x position into dynamic formatting)
3) Rewinded segue using existing and additional buttons to help dissolve view stacking leading to memory issues

# How to create segue between two view controllers:
You can do this one of two ways:
1) UI
  - Click on the button or object you want to trigger a segue, click and drag the object to the view controller holding down ctrl
2) Code
  - First, link the two view controllers through segue by clicking on the top left icon called "View Controller" while holding ctrl and dragging it to the destination view controller
  - Click on the specific segue you just created and click on the tab that looks like a spinning top on the top right of the screen
    - Make sure that the right inspector is open (the very top right button)
  - Type in "Identifier" a name you want to assign this segue
  - In the view controller code, perform the segue using this name
    - For ex: go to LevelOneGame.swift viewcontroller and look at function "Submit"
      - performSegue method uses paramemter "withIdentifier" with the name assigned to the segue to perform that segue for this action.
* EITHER WAYS, click on the segue (with the right inspector open) and the tab that looks like a spinning top as mentioned above, and change "Presentation" to "Full Screen".

# How to unwind segue:
1) Go to the view controller file (swift) and create an IBAction function (DON'T LINK IT TO ANYTHING making sure that the sender is the UIStoryboardSegue.
- For ex: Go to LevelSelectorViewController.swift and see the empty function
- It can be empty because the function just needs to be located in the target view controller to unwind the segue back.
2) Go to the Main.storyboard and find the button within a view that you want to trigger the unwind segue action. While holding 'ctrl', click on the button and drag (link) it to the top right icon of the view (it says exit)
3) It'll give you the option to link it to a specific IBAction. Choose, the function you named before to unwind the segue.

# How to create additional view/view controllers:
1) Create a new file in the directory by right clicking the folder on the left and choosing "New File..."
2) Choose "Cocoa Touch Class" in the "iOS" tab if it's not already chosen by default, click "Next", click "Create"
3) Name it whatever name you want but MAKE SURE it is a subclass of "UIViewController"
4) Go to Main.storyboard
5) Press Command + Shift + "L" or click on the "+" sign located at the top right screen which will bring up a pop up.
6) Type in "View Controller"
7) Drag the view controller onto the storyboard
8) Make sure that the right inspector is open (the very top right button)
9) Click on the top of the view controller, making sure that it's selected, and click on the newspaper looking button on the top of the right inspector.
10) Click on the drop down for "Class" and choose the view controller's name that you created before to link the file itself to the UI view controller

# How to add UI objects to a view controller:
You can do this one of two ways:
1) Copy/Paste:
  - CONNOR this is what you should do since you have levels 5 and 6 done. This should take no time at all to do since it's just copying over and pasting.
    - If you have view controllers from a different Xcode storyboard that you want to copy over, you can select object on the view controller one by one, press command + "c" to copy, go the the view controller on the storyboard you want to paste it to, click on the view controller to select it, press command + "v" to paste (right clicking doesn't work for this so use commands, and ignore the constraints during the copying and pasting since most should just copy over if you select all the objects).
    - Check all the constraints to make sure everything copied over. If not, just readd the ones that didn't.
    - Copy over the view controller swift file to the folder.
    - Delete and Relink all IBOutlets and IBActions since copying over will cut the links (even though it doesn't seem like it did, it will throw a whole bunch of errors and crash if you don't delete and relink).

2) Creating From Scratch:
  - Make sure you are in the Main.storyboard
    - Use the library command again (Command + Shift + "L" or click on the "+" sign located at the top right sreen), and type in buttons, image, label, etc. and drag in the UI objects.
    - Set up all elements including constraints in the UI
    - To use the UI objects in code, click on the button on the top mid-right that has a whole bunch of lines going down on the left of what looks like two rectangles inside of each other.
    - Click on "Assistant" (head up: this will split the screen more since another screen is being added)
    - The screen that just got added is the code that correspondes to each view controller you select. 
    - Select the view controller you are editing
    - Select the object you want to use/link
    - If it's an object that you want use for indirect user-interactive purposes (label, image, button, etc.), click on the object and press ctrl while dragging onto the "Assistant" screen above the function viewDidLoad. It should say "Insert Action, Outlet, or Outlet Collection". Let go, make sure it says "Outlet", and name it whatever you want (essentially it's a variable for an object you created on the UI)
    - If you want to link the action of pressing a button to a specific function, create a IBAction function below the function viewDidLoad, and click/drag the button as mentioned above (h) but INTO the function this time. This will allow the function to be called when the user interacts with the object.

