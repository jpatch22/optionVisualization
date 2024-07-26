class RowDataExtended {
  String longShort;
  String type;
  String contractPrice;
  String timeToExpiry;

  RowDataExtended({
    this.longShort = 'Long',
    this.type = 'Put',
    this.contractPrice = '',
    this.timeToExpiry = '',
  });

  // Method to convert to a map
  Map<String, dynamic> toJson() {
    return {
      'longShort': longShort,
      'optionType': type,
      'contractPrice': contractPrice,
      'timeToExpiry': timeToExpiry,
    };
  }
}
