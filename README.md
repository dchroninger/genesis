# Genesis Infotainment

## Purpose

The main purpose of this project is to get started with learning how to build a custom infotainment system for my project car. The goal is to integrate it with the CANbus system as well as climate control and other features of the car. This should provide both a central cluster UI as we as a "center stack" UI for the center of the dashboard.

Honestly I have no idea how I'm going to implement this just yet. Dear IMGUI seems like a viable option, which I could use with Golang, or I could take the opportunity to learn C or C++ and use that instead. This will mostly be a learning project, and hopefully I'll get he chance to put the system on some hardware and mount it into the car.

## Requirements

- Display vehicle statistics and diagnostics information:
  - Speed (MPH/KPH)
  - RPM
  - CEL (Have ability to decode)
  - Voltage
  - Light indicators and statuses
  - Boost pressure (integrating with external boost sensor)
  - Air/Fuel ratio (External sensor here too)
- Provide standard infotainment features:
  - Ability to play music (bluetooth? How is Apple CarPlay implemented?)
  - Navigation (Google Maps API?)
- UI for system controls:
  - HVAC
  - Trunk release
  - Gas door release
  - Power Folding Mirrors
  - Mirror and window defrosters
  - Windows (would be cool, but the door switches aren't going anywhere anytime soon)
  - Interior lighting
  - Puddle Light controls

## Expectations

This project is likely going to take a few years, and this repo will be a bit of a mess while I explore options and see what tools work best here. Language, dependencies, etc. are all up in the air. I'm going to try to keep the README up to date with my thoughts and progress, but I'm not going to be too strict about it.

## Current Path

Right now I think I'll explore getting IMGUI set up in Golang using the generated C bindings. There are some limitations there when it comes to slices, but the issues seem trivial currently for what I'm expecting. If these limitations start causing problems, I can either explore moving to C++ or C, or I can try working without IMGUI and render directly with GLFW or similar.

## Hardware

I need to see what sort of compute and GPU requirements will need to be met for this to work in an automotive setting. There will need to be 2 displays regardless, but a big thing to figure out is if I will need 1 or 2 controllers for them. If I go with 2, I can just network them together over Ethernet. AGL (Automotive Grade Linux) may be a good option for this too once I get something compiling and rendering.
