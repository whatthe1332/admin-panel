import './inventory.dart';

List<Inventory> dummyInventories = _json.map((json) {
  if (json
      case {
        'inventoryId': final String inventoryId,
        'category': final String category,
        'brand': final String brand,
        'supplier': final String supplier,
        'minimumStock': final int minimumStock,
        'updateDate': final String updateDate,
        'taxRate': final double taxRate,
        'notes': final String notes,
        'productSize': final String productSize,
        'productWeight': final String productWeight,
        'partnershipProgramInfo': final String partnershipProgramInfo,
        'storageLocation': final String storageLocation,
      }) {
    return Inventory(
      inventoryId: inventoryId,
      category: category,
      brand: brand,
      supplier: supplier,
      minimumStock: minimumStock,
      updateDate: updateDate,
      taxRate: taxRate,
      notes: notes,
      productSize: productSize,
      productWeight: productWeight,
      partnershipProgramInfo: partnershipProgramInfo,
      storageLocation: storageLocation,
    );
  } else {
    throw const FormatException('Unexpected JSON');
  }
}).toList();

// Generated by ChatGPT
const _json = [
  {
    'inventoryId': 'INV001',
    'category': 'Electronics',
    'brand': 'Sony',
    'supplier': 'ABC Electronics Ltd.',
    'minimumStock': 10,
    'updateDate': '2023-08-15',
    'taxRate': 0.08,
    'notes': 'New model',
    'productSize': '30x40x10cm',
    'productWeight': '2.5kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse A',
  },
  {
    'inventoryId': 'INV002',
    'category': 'Fashion',
    'brand': 'Nike',
    'supplier': 'XYZ Fashion Inc.',
    'minimumStock': 20,
    'updateDate': '2023-08-10',
    'taxRate': 0.1,
    'notes': 'New color added',
    'productSize': 'M',
    'productWeight': '0.5kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse B',
  },
  {
    'inventoryId': 'INV003',
    'category': 'Home',
    'brand': 'KitchenAid',
    'supplier': 'Home Comforts Inc.',
    'minimumStock': 15,
    'updateDate': '2023-08-20',
    'taxRate': 0.09,
    'notes': 'Improved model',
    'productSize': '20x20x30cm',
    'productWeight': '4kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse C',
  },
  {
    'inventoryId': 'INV004',
    'category': 'Sports',
    'brand': 'Adidas',
    'supplier': 'Sports Gear Co.',
    'minimumStock': 25,
    'updateDate': '2023-08-18',
    'taxRate': 0.1,
    'notes': 'Limited edition',
    'productSize': 'L',
    'productWeight': '0.6kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse D',
  },
  {
    'inventoryId': 'INV005',
    'category': 'Electronics',
    'brand': 'Apple',
    'supplier': 'Tech Innovations Ltd.',
    'minimumStock': 12,
    'updateDate': '2023-08-12',
    'taxRate': 0.1,
    'notes': 'Latest model',
    'productSize': '25x35x5cm',
    'productWeight': '1.2kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse E',
  },
  {
    'inventoryId': 'INV006',
    'category': 'Home',
    'brand': 'IKEA',
    'supplier': 'Home Furnishings Inc.',
    'minimumStock': 18,
    'updateDate': '2023-08-22',
    'taxRate': 0.08,
    'notes': 'Assembly required',
    'productSize': '40x60x80cm',
    'productWeight': '10kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse F',
  },
  {
    'inventoryId': 'INV007',
    'category': 'Sports',
    'brand': 'Nike',
    'supplier': 'Sports Gear Co.',
    'minimumStock': 30,
    'updateDate': '2023-08-14',
    'taxRate': 0.1,
    'notes': 'High-demand item',
    'productSize': 'XL',
    'productWeight': '0.7kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse G',
  },
  {
    'inventoryId': 'INV008',
    'category': 'Electronics',
    'brand': 'Samsung',
    'supplier': 'Tech Innovations Ltd.',
    'minimumStock': 14,
    'updateDate': '2023-08-19',
    'taxRate': 0.1,
    'notes': 'Improved performance',
    'productSize': '22x32x4cm',
    'productWeight': '1.0kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse H',
  },
  {
    'inventoryId': 'INV009',
    'category': 'Fashion',
    'brand': 'Gucci',
    'supplier': 'Luxury Fashion House',
    'minimumStock': 22,
    'updateDate': '2023-08-11',
    'taxRate': 0.15,
    'notes': 'Designer collection',
    'productSize': 'S',
    'productWeight': '0.4kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse I',
  },
  {
    'inventoryId': 'INV010',
    'category': 'Home',
    'brand': 'Dyson',
    'supplier': 'Home Innovations Inc.',
    'minimumStock': 8,
    'updateDate': '2023-08-16',
    'taxRate': 0.08,
    'notes': 'Advanced technology',
    'productSize': '18x22x40cm',
    'productWeight': '3.0kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse J',
  },
  {
    'inventoryId': 'INV011',
    'category': 'Electronics',
    'brand': 'LG',
    'supplier': 'Tech Innovations Ltd.',
    'minimumStock': 11,
    'updateDate': '2023-08-13',
    'taxRate': 0.1,
    'notes': 'Energy-efficient',
    'productSize': '28x38x7cm',
    'productWeight': '1.2kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse K',
  },
  {
    'inventoryId': 'INV012',
    'category': 'Fashion',
    'brand': 'Prada',
    'supplier': 'Luxury Fashion House',
    'minimumStock': 20,
    'updateDate': '2023-08-09',
    'taxRate': 0.15,
    'notes': 'Exclusive collection',
    'productSize': 'M',
    'productWeight': '0.6kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse L',
  },
  {
    'inventoryId': 'INV013',
    'category': 'Sports',
    'brand': 'Puma',
    'supplier': 'Sports Gear Co.',
    'minimumStock': 25,
    'updateDate': '2023-08-17',
    'taxRate': 0.1,
    'notes': 'Popular choice',
    'productSize': 'L',
    'productWeight': '0.7kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse M',
  },
  {
    'inventoryId': 'INV014',
    'category': 'Electronics',
    'brand': 'Microsoft',
    'supplier': 'Tech Innovations Ltd.',
    'minimumStock': 16,
    'updateDate': '2023-08-21',
    'taxRate': 0.1,
    'notes': 'Enhanced features',
    'productSize': '24x34x6cm',
    'productWeight': '1.1kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse N',
  },
  {
    'inventoryId': 'INV015',
    'category': 'Fashion',
    'brand': 'Versace',
    'supplier': 'Luxury Fashion House',
    'minimumStock': 19,
    'updateDate': '2023-08-08',
    'taxRate': 0.15,
    'notes': 'Signature collection',
    'productSize': 'S',
    'productWeight': '0.5kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse O',
  },
  {
    'inventoryId': 'INV016',
    'category': 'Home',
    'brand': 'Bosch',
    'supplier': 'Home Innovations Inc.',
    'minimumStock': 10,
    'updateDate': '2023-08-23',
    'taxRate': 0.08,
    'notes': 'Smart home technology',
    'productSize': '22x22x35cm',
    'productWeight': '3.2kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse P',
  },
  {
    'inventoryId': 'INV017',
    'category': 'Sports',
    'brand': 'Under Armour',
    'supplier': 'Sports Gear Co.',
    'minimumStock': 28,
    'updateDate': '2023-08-16',
    'taxRate': 0.1,
    'notes': 'Performance wear',
    'productSize': 'XL',
    'productWeight': '0.8kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse Q',
  },
  {
    'inventoryId': 'INV018',
    'category': 'Electronics',
    'brand': 'HP',
    'supplier': 'Tech Innovations Ltd.',
    'minimumStock': 14,
    'updateDate': '2023-08-22',
    'taxRate': 0.1,
    'notes': 'Business edition',
    'productSize': '26x36x8cm',
    'productWeight': '1.0kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse R',
  },
  {
    'inventoryId': 'INV019',
    'category': 'Fashion',
    'brand': 'H&M',
    'supplier': 'Fashion Trends Inc.',
    'minimumStock': 22,
    'updateDate': '2023-08-07',
    'taxRate': 0.1,
    'notes': 'Seasonal collection',
    'productSize': 'M',
    'productWeight': '0.6kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse S',
  },
  {
    'inventoryId': 'INV020',
    'category': 'Home',
    'brand': 'Panasonic',
    'supplier': 'Home Innovations Inc.',
    'minimumStock': 12,
    'updateDate': '2023-08-24',
    'taxRate': 0.08,
    'notes': 'Energy-efficient',
    'productSize': '21x31x5cm',
    'productWeight': '1.1kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse T',
  },
  {
    'inventoryId': 'INV021',
    'category': 'Sports',
    'brand': 'Columbia',
    'supplier': 'Sports Gear Co.',
    'minimumStock': 30,
    'updateDate': '2023-08-15',
    'taxRate': 0.1,
    'notes': 'Outdoor gear',
    'productSize': 'L',
    'productWeight': '0.7kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse U',
  },
  {
    'inventoryId': 'INV022',
    'category': 'Electronics',
    'brand': 'Lenovo',
    'supplier': 'Tech Innovations Ltd.',
    'minimumStock': 13,
    'updateDate': '2023-08-20',
    'taxRate': 0.1,
    'notes': 'Business laptop',
    'productSize': '27x37x7cm',
    'productWeight': '1.2kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse V',
  },
  {
    'inventoryId': 'INV023',
    'category': 'Fashion',
    'brand': 'Zara',
    'supplier': 'Fashion Trends Inc.',
    'minimumStock': 24,
    'updateDate': '2023-08-06',
    'taxRate': 0.1,
    'notes': 'Seasonal collection',
    'productSize': 'S',
    'productWeight': '0.5kg',
    'partnershipProgramInfo': 'None',
    'storageLocation': 'Warehouse W',
  },
  {
    'inventoryId': 'INV024',
    'category': 'Home',
    'brand': 'Siemens',
    'supplier': 'Home Innovations Inc.',
    'minimumStock': 11,
    'updateDate': '2023-08-25',
    'taxRate': 0.08,
    'notes': 'Smart home appliances',
    'productSize': '23x33x6cm',
    'productWeight': '2.0kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse X',
  },
  {
    'inventoryId': 'INV025',
    'category': 'Sports',
    'brand': 'The North Face',
    'supplier': 'Sports Gear Co.',
    'minimumStock': 27,
    'updateDate': '2023-08-14',
    'taxRate': 0.1,
    'notes': 'Outdoor gear',
    'productSize': 'XL',
    'productWeight': '0.8kg',
    'partnershipProgramInfo': 'Available',
    'storageLocation': 'Warehouse Y',
  },
];
