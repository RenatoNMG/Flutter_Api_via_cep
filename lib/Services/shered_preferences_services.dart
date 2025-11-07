
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SheredPreferencesServices {
  
  static SheredPreferencesServices? _instance;

  static SharedPreferences? _preferences;

  SheredPreferencesServices();

  Future<SheredPreferencesServices> init() async {
    if (_instance == null) {
      _instance = SheredPreferencesServices();

      _preferences = await SharedPreferences.getInstance();

      return _instance!;
    }
    return _instance!;
  }

  Future<bool> saveInt(String key, int value) async {
    try {
      bool result = await _preferences!.setInt(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao Salvar Inteiro: $erro");
      return false;
    }
  }

  Future<bool> saveString(String key, String value) async {
    try {
      bool result = await _preferences!.setString(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao Salvar Inteiro: $erro");
      return false;
    }
  }

  Future<bool> saveBool(String key, bool value) async {
    try {
      bool result = await _preferences!.setBool(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao Salvar Inteiro: $erro");
      return false;
    }
  }

  Future<bool> saveList(String key, List<String> value) async {
    try {
      bool result = await _preferences!.setStringList(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao Salvar Inteiro: $erro");
      return false;
    }
  }

  int? getInt(String key) {
    try {
      return _preferences!.getInt(key);
    } catch (erro) {
      debugPrint("Falha ao buscar int Inteiro: $erro");
      return null;
    }
  }

  String? getString(String key) {
    try {
      return _preferences!.getString(key);
    } catch (erro) {
      debugPrint("Falha ao buscar String Inteiro: $erro");
      return null;
    }
  }

  double? getDouble(String key) {
    try {
      return _preferences!.getDouble(key);
    } catch (erro) {
      debugPrint("Falha ao buscar double Inteiro: $erro");
      return null;
    }
  }

  bool? getBool(String key) {
    try {
      return _preferences!.getBool(key);
    } catch (erro) {
      debugPrint("Falha ao buscar bool Inteiro: $erro");
      return null;
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _preferences!.getStringList(key);
    } catch (erro) {
      debugPrint("Falha ao buscar lista de string Inteiro: $erro");
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return await _preferences!.remove(key);
    } catch (erro) {
      debugPrint("erro ao remover a Chave $key erro; $key");
      return false;
    }
  }

  Future<bool> clearALL() async {
    try {
      return await _preferences!.clear();
    } catch (erro) {
      debugPrint("erro ao limpar tudo");
      return false;
    }
  }

  bool containsKey(String key) {
    try {
      return _preferences!.containsKey(key);
    } catch (erro) {
      debugPrint("erro ao verificar chave");
      return false;
    }
  }

  Set<String> getKeys() {
    try {
      return _preferences!.getKeys();
    } catch (erro) {
      return {};
    }
  }
}
