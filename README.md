# ImageSeeker (Coding Challenge by SAP)

![appIcon](https://user-images.githubusercontent.com/66749542/141722780-a9230027-7dcc-4268-8814-1763fa8bd197.jpg)

<h3> Problem statement: </h3>
Your task is to create an iOS mobile app that uses the Flickr image search API and shows the results in a scrollable view. <br>
<h4> Functional Requirements </h4>

- The searched results should be shown in a scrollable view.
- The scrollable view should be endless. How this is implemented in detail is up to you. 

<p> Bonus: Consider multiple different ways to implement it and pick one. </p> 
  
- The user can see the search history.
- You are allowed to use any 3rd party libraries.
- Use UIKit only, no SwiftUI. 
<h4> Nice to have: </h4>

- Consider how to improve the general user experience with your expertise. 

<h4> Non-Functional Requirements </h4>

- The implemented features are unit tested.
- Errors and edge-cases are considered.
- Best practices regarding architecture and code style are considered.

<h3> Solution: </h3>

My solution is a simple and intuitive app which consists of 2 screens. One for the infinite collection view and another for the search history. <br>
I followed the MVVM architectural pattern and when it came to connecting the vm with the vc I made use of TwoWayBondage ( Third party library, similiar to RXSwift) <br>

PS: I wanted to make the default screen an overview of flickr recent photos, making use of another endpoint. However due to inaproppriate content on the website I had to scratch that idea.!
