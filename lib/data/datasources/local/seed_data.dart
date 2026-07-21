import '../../models/ir_device_model.dart';
import 'dart:math';

List<IrDeviceModel> getSeedData() {
  final List<IrDeviceModel> devices = [];
  int idCounter = 1;
  final random = Random(42); // seed for deterministic output

  // --- TV BRANDS ---
  final List<String> tvBrands = [
    'A', 'ABASK', 'Abion', 'ABL', 'ACD', 'Acekool', 'Acer', 'ACL', 'Admiral', 'Aiwa', 'Akai', 'AOC',
    'B&O', 'BPL', 'Bush',
    'Carrier', 'Chigo', 'Coby', 'Compaq', 'Craig', 'Crown',
    'Daewoo', 'Dell', 'Dynex',
    'Element', 'Emerson', 'Epson',
    'Funai', 'Gateway', 'GE', 'GoldStar', 'Haier', 'Hisense', 'Hitachi', 'HP', 'Hyundai',
    'Insignia', 'JVC', 'LG', 'Magnavox', 'Marantz', 'Micromax', 'Mitsubishi', 'NEC',
    'Onida', 'Panasonic', 'Philips', 'Pioneer', 'Polaroid', 'Proscan',
    'RCA', 'Redmi', 'Samsung', 'Sanyo', 'Sharp', 'Sony', 'Sylvania',
    'TCL', 'Toshiba', 'Vizio', 'Vu', 'Westinghouse', 'Xiaomi', 'Zenith'
  ];

  final tvButtons = {
    'power': [9000, 4500, 560, 560],
    'mute': [9000, 4500, 560, 560],
    'vol_up': [9000, 4500, 560, 560],
    'vol_down': [9000, 4500, 560, 560],
    'ch_up': [9000, 4500, 560, 560],
    'ch_down': [9000, 4500, 560, 560],
    'up': [9000, 4500, 560, 560],
    'down': [9000, 4500, 560, 560],
    'left': [9000, 4500, 560, 560],
    'right': [9000, 4500, 560, 560],
    'ok': [9000, 4500, 560, 560],
    'home': [9000, 4500, 560, 560],
    'back': [9000, 4500, 560, 560],
  };

  for (final brand in tvBrands) {
    // Generate 5-10 models per brand
    final numModels = random.nextInt(6) + 5;
    for (int i = 1; i <= numModels; i++) {
      devices.add(
        IrDeviceModel(
          id: idCounter++,
          category: 'TV',
          brand: brand,
          series: 'Series ${String.fromCharCode(65 + random.nextInt(26))}', // Series A-Z
          model: 'Model $i-${random.nextInt(9000) + 1000}',
          carrierFrequency: 38000,
          buttons: tvButtons,
        )
      );
    }
  }

  // --- AC BRANDS ---
  final List<String> acBrands = [
    'A', 'Airwell', 'Amstrad', 'Beko', 'Blue Star', 'Bosch', 'Carrier', 'Chigo',
    'Croma', 'Daikin', 'Electrolux', 'Frigidaire', 'Fujitsu', 'GE', 'Godrej',
    'Gree', 'Haier', 'Hisense', 'Hitachi', 'Hyundai', 'IFB', 'Kelvinator',
    'Kenstar', 'LG', 'Lloyd', 'Micromax', 'Midea', 'Mitsubishi', 'O General',
    'Onida', 'Panasonic', 'Philips', 'Samsung', 'Sanyo', 'Sharp', 'TCL',
    'Toshiba', 'Trane', 'Videocon', 'Voltas', 'Whirlpool', 'York'
  ];

  final acButtons = {
    'power': [3000, 3000, 400, 400],
    'swing': [3000, 3000, 400, 400],
    'temp_up': [3000, 3000, 400, 400],
    'temp_down': [3000, 3000, 400, 400],
    'mode': [3000, 3000, 400, 400],
    'auto': [3000, 3000, 400, 400],
    'cool': [3000, 3000, 400, 400],
    'heating': [3000, 3000, 400, 400],
    'dry': [3000, 3000, 400, 400],
    'fan': [3000, 3000, 400, 400],
    'sleep': [3000, 3000, 400, 400],
    'timer': [3000, 3000, 400, 400],
    'direction': [3000, 3000, 400, 400],
    'fan speed': [3000, 3000, 400, 400],
    'more': [3000, 3000, 400, 400],
  };

  for (final brand in acBrands) {
    // Generate 5-10 models per brand
    final numModels = random.nextInt(6) + 5;
    for (int i = 1; i <= numModels; i++) {
      devices.add(
        IrDeviceModel(
          id: idCounter++,
          category: 'AC',
          brand: brand,
          series: 'Inverter ${random.nextInt(3) + 1} Ton',
          model: 'Model $i-${random.nextInt(9000) + 1000}',
          carrierFrequency: 38000,
          buttons: acButtons,
        )
      );
    }
  }

  return devices;
}
