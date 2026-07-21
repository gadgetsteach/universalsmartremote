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

  // Provide a generic realistic NEC pattern so it won't fail Android IR transmitter tests
  List<int> generateGenericNecPattern(int seed) {
    final pattern = <int>[9000, 4500];
    final localRandom = Random(seed);
    for (int i = 0; i < 32; i++) {
      pattern.add(560);
      pattern.add(localRandom.nextBool() ? 1690 : 560);
    }
    pattern.add(560);
    return pattern;
  }

  final tvButtons = {
    'power': generateGenericNecPattern(1),
    'mute': generateGenericNecPattern(2),
    'vol_up': generateGenericNecPattern(3),
    'vol_down': generateGenericNecPattern(4),
    'ch_up': generateGenericNecPattern(5),
    'ch_down': generateGenericNecPattern(6),
    'up': generateGenericNecPattern(7),
    'down': generateGenericNecPattern(8),
    'left': generateGenericNecPattern(9),
    'right': generateGenericNecPattern(10),
    'ok': generateGenericNecPattern(11),
    'home': generateGenericNecPattern(12),
    'back': generateGenericNecPattern(13),
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

  Map<String, List<int>> generateCompositeAcButtons(int modelCode, int bitLength) {
    // AC remote signals transmit composite data packets containing the complete state
    // (including mode, fan speed, and exact temperature) rather than single function commands.
    // This generates a pseudo-valid composite IR pattern of the specified bit length.
    List<int> generatePattern(int seed) {
      final pattern = <int>[3400, 1750];
      final localRandom = Random(seed);
      for (int i = 0; i < bitLength; i++) {
        pattern.add(450); // mark
        if (localRandom.nextBool()) {
          pattern.add(1300); // space for 1
        } else {
          pattern.add(420); // space for 0
        }
      }
      pattern.add(450); // stop mark
      pattern.add(1750); // stop space
      return pattern;
    }

    return {
      'power': generatePattern(modelCode * 10 + 1),
      'swing': generatePattern(modelCode * 10 + 2),
      'temp_up': generatePattern(modelCode * 10 + 3),
      'temp_down': generatePattern(modelCode * 10 + 4),
      'mode': generatePattern(modelCode * 10 + 5),
      'auto': generatePattern(modelCode * 10 + 6),
      'cool': generatePattern(modelCode * 10 + 7),
      'heating': generatePattern(modelCode * 10 + 8),
      'dry': generatePattern(modelCode * 10 + 9),
      'fan': generatePattern(modelCode * 10 + 10),
      'sleep': generatePattern(modelCode * 10 + 11),
      'timer': generatePattern(modelCode * 10 + 12),
      'direction': generatePattern(modelCode * 10 + 13),
      'fan speed': generatePattern(modelCode * 10 + 14),
      'more': generatePattern(modelCode * 10 + 15),
    };
  }

  final acButtons = {
    'power': generateGenericNecPattern(101),
    'swing': generateGenericNecPattern(102),
    'temp_up': generateGenericNecPattern(103),
    'temp_down': generateGenericNecPattern(104),
    'mode': generateGenericNecPattern(105),
    'auto': generateGenericNecPattern(106),
    'cool': generateGenericNecPattern(107),
    'heating': generateGenericNecPattern(108),
    'dry': generateGenericNecPattern(109),
    'fan': generateGenericNecPattern(110),
    'sleep': generateGenericNecPattern(111),
    'timer': generateGenericNecPattern(112),
    'direction': generateGenericNecPattern(113),
    'fan speed': generateGenericNecPattern(114),
    'more': generateGenericNecPattern(115),
  };

  void addAcModel(String brand, int modelId, int bitLength) {
    devices.add(
      IrDeviceModel(
        id: idCounter++,
        category: 'AC',
        brand: brand,
        series: 'Inverter',
        model: 'Model ${modelId.toString().padLeft(3, '0')}',
        carrierFrequency: 38000,
        buttons: generateCompositeAcButtons(modelId, bitLength),
      )
    );
  }

  for (final brand in acBrands) {
    if (brand == 'Mitsubishi') {
      // Mitsubishi: 551-599
      for (int i = 551; i <= 599; i++) {
        addAcModel(brand, i, 144);
      }
    } else if (brand == 'Gree') {
      // Gree: 000, 020-039
      addAcModel(brand, 0, 64);
      for (int i = 20; i <= 39; i++) {
        addAcModel(brand, i, 64);
      }
    } else if (brand == 'LG') {
      // LG: 600-609
      for (int i = 600; i <= 609; i++) {
        addAcModel(brand, i, 104);
      }
    } else {
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
  }

  return devices;
}
