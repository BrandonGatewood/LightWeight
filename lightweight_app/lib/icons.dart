import "package:flutter/material.dart";

class MyIcons {

  Icon deleteIcon() {
    return const Icon( 
      Icons.highlight_remove_outlined,
      color: Colors.white,
      size: 30,
    );
  }

  Icon backArrowIcon() {
    return const Icon(
      Icons.arrow_back_ios_new_rounded,
      color: Colors.white,
      size: 30,
    );
  }

  Icon addIcon() {
    return const Icon(
      Icons.add_rounded,
      color: Colors.white,
      size: 30,
    );
  }

  Icon checkIcon() {
    return const Icon(
      Icons.check_rounded,
      color: Colors.white,
      size: 30,
    );

  }
}