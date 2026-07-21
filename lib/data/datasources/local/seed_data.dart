import '../../models/ir_device_model.dart';

List<IrDeviceModel> getSeedData() {
  return [
    // TV Brands
    // Samsung TVs
    IrDeviceModel(
      id: 1,
      category: 'TV',
      brand: 'Samsung',
      series: 'Smart TV',
      model: 'Model 1',
      carrierFrequency: 38000,
      buttons: {
        'power': [9000, 4500, 560, 560], // Dummy codes
        'vol_up': [9000, 4500, 560, 560],
        'vol_down': [9000, 4500, 560, 560],
        'ch_up': [9000, 4500, 560, 560],
        'ch_down': [9000, 4500, 560, 560],
        'mute': [9000, 4500, 560, 560],
        'up': [9000, 4500, 560, 560],
        'down': [9000, 4500, 560, 560],
        'left': [9000, 4500, 560, 560],
        'right': [9000, 4500, 560, 560],
        'ok': [9000, 4500, 560, 560],
        'home': [9000, 4500, 560, 560],
        'back': [9000, 4500, 560, 560],
      },
    ),
    IrDeviceModel(
      id: 2,
      category: 'TV',
      brand: 'Samsung',
      series: 'Older TV',
      model: 'Model 2',
      carrierFrequency: 38000,
      buttons: {
        'power': [8000, 4000, 500, 500],
        'vol_up': [8000, 4000, 500, 500],
        'vol_down': [8000, 4000, 500, 500],
      },
    ),
    // LG TVs
    IrDeviceModel(
      id: 3,
      category: 'TV',
      brand: 'LG',
      series: 'WebOS',
      model: 'Model 1',
      carrierFrequency: 38000,
      buttons: {
        'power': [9000, 4500, 560, 560], 
        'vol_up': [9000, 4500, 560, 560],
        'vol_down': [9000, 4500, 560, 560],
        'ch_up': [9000, 4500, 560, 560],
        'ch_down': [9000, 4500, 560, 560],
        'mute': [9000, 4500, 560, 560],
      },
    ),
    IrDeviceModel(
      id: 4,
      category: 'TV',
      brand: 'Sony',
      series: 'Bravia',
      model: 'Model 1',
      carrierFrequency: 40000,
      buttons: {
        'power': [2400, 600, 1200, 600], 
        'vol_up': [2400, 600, 1200, 600],
        'vol_down': [2400, 600, 1200, 600],
      },
    ),
    
    // AC Brands
    IrDeviceModel(
      id: 5,
      category: 'AC',
      brand: 'Daikin',
      series: 'Inverter',
      model: 'Model 1',
      carrierFrequency: 38000,
      buttons: {
        'power': [3000, 3000, 400, 400], 
        'temp_up': [3000, 3000, 400, 400],
        'temp_down': [3000, 3000, 400, 400],
        'mode': [3000, 3000, 400, 400],
        'fan': [3000, 3000, 400, 400],
        'swing': [3000, 3000, 400, 400],
      },
    ),
    IrDeviceModel(
      id: 6,
      category: 'AC',
      brand: 'Voltas',
      series: 'Split',
      model: 'Model 1',
      carrierFrequency: 38000,
      buttons: {
        'power': [3000, 3000, 400, 400], 
        'temp_up': [3000, 3000, 400, 400],
        'temp_down': [3000, 3000, 400, 400],
        'mode': [3000, 3000, 400, 400],
        'fan': [3000, 3000, 400, 400],
      },
    ),
    IrDeviceModel(
      id: 7,
      category: 'AC',
      brand: 'LG',
      series: 'Dual Inverter',
      model: 'Model 1',
      carrierFrequency: 38000,
      buttons: {
        'power': [3000, 3000, 400, 400], 
        'temp_up': [3000, 3000, 400, 400],
        'temp_down': [3000, 3000, 400, 400],
        'mode': [3000, 3000, 400, 400],
      },
    ),
  ];
}
