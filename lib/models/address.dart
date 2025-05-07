class Address {
  String? name;
  int? docstatus;
  String? addressTitle;
  String? addressType;
  String? addressLine1;
  String? city;
  String? country;
  int? isPrimaryAddress;
  int? isShippingAddress;
  int? disabled;
  int? isYourCompanyAddress;

  Address({
    this.name,
    this.docstatus,
    this.addressTitle,
    this.addressType,
    this.addressLine1,
    this.city,
    this.country,
    this.isPrimaryAddress,
    this.isShippingAddress,
    this.disabled,
    this.isYourCompanyAddress,
  });

  Address.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    docstatus = json['docstatus'];
    addressTitle = json['address_title'];
    addressType = json['address_type'];
    addressLine1 = json['address_line1'];
    city = json['city'];
    country = json['country'];
    isPrimaryAddress = json['is_primary_address'];
    isShippingAddress = json['is_shipping_address'];
    disabled = json['disabled'];
    isYourCompanyAddress = json['is_your_company_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['docstatus'] = docstatus;
    data['address_title'] = addressTitle;
    data['address_type'] = addressType;
    data['address_line1'] = addressLine1;
    data['city'] = city;
    data['country'] = country;
    data['is_primary_address'] = isPrimaryAddress;
    data['is_shipping_address'] = isShippingAddress;
    data['disabled'] = disabled;
    data['is_your_company_address'] = isYourCompanyAddress;
    return data;
  }
}
