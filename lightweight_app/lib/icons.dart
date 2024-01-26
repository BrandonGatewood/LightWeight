import "package:flutter/material.dart";

class MyIcons {
  Icon deleteIcon() {
    return const Icon( 
      Icons.delete_rounded,
      color: Colors.white,
      size: 25,
    );
  }

  Icon decrementIcon() {
    return const Icon( 
      Icons.remove_rounded,
      color: Colors.white,
      size: 25,
    );
  }

  Icon incrementIcon() {
    return const Icon(
      Icons.add_rounded,
      color: Colors.white,
      size: 25,
    );
  }

  Icon backArrowIcon() {
    return const Icon(
      Icons.arrow_back_ios_new_rounded,
      color: Colors.white,
      size: 25,
    );
  }
  
  Icon forwardArrowIcon() {
    return const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
      size: 20,
    );
  }

  Icon addIcon() {
    return const Icon(
      Icons.add_rounded,
      color: Colors.white,
      size: 25,
    );
  }

  Icon checkIcon() {
    return const Icon(
      Icons.check_rounded,
      color: Colors.white,
      size: 25,
    );
  }
  
  Icon editIcon() {
    return const Icon( 
      Icons.edit_rounded,
      color: Colors.white,
      size: 25,
    );
  }

}