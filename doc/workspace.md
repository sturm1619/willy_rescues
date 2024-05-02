# Repository management - Notes

## Info

- Original:
  - Author: Carlos Rubio
    - github: sturm1619
    - UVU email: Carlos.Rubio@uvu.edu || 11006941@uvu.edu
  - Version: v0.0
  - Date: 2024-05-02 (Thursday May 2, 2024)

- Current:
  - Author: Carlos Rubio
    - github: sturm1619
    - email:  Carlos.Rubio@uvu.edu || 11006941@uvu.edu
  - Version: v0.0
  - Date: 2024-05-02 (Thursday May 2, 2024)

## General Rules

1. If you have to change the path to a file that has been merged to the main, just merge your changes to the "dev" branch and pull, then contact the remote repository manager (in other words, me). The team will discuss the request in the next pull request review meeting.

2. Create a new directory/folder if you have to name a bundle of files with the same prefixes. E.g.: Instead of:

> res://asset/sprite/tileset_library.jpg and res://asset/sprite/tileset_cs_building.jpg

do

> res://asset/sprite/tileset/library.jpg and res://asset/sprite/cs_building.jpg

3. Naming conventions
  - Use snake_case for files in:
    - asset/
    - doc/
  - Use camelCase for files in:
    - scene/
    - sprite/

## Remote Repository branch tree

- master: DO NOT MODIFY THIS ONE. This branch contains the files intended for release.
- production: Merge the final version of the features into this one.

## Workspace tree

> res://
> ├── asset
> │   ├── background
> │   ├── sprite
> │   └── tileset
> ├── doc
> │   └── workspace.md
> ├── project.godot                   # Main Godot file
> ├── scene
> └── script
