// ignore_for_file: unnecessary_this

extension DoubleExtension on double {
  double get removeDecimalZeroFormat {
    if (this.toString().contains('.')) {
      return double.parse(this.toString().replaceAll(
              RegExp(r"([.]*0+)(?!.*\d)"),
              "") //remove all trailing 0's and extra decimals at end if any
          );
    } else {
      return this;
    }
  }
}
