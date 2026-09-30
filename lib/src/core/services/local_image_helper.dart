class LocalImageHelper {
  // Map document IDs to exact local asset filenames in Externalasset/
  static const Map<String, String> docIdToFilename = {
    'app_1': 'Quesadilla.jpg',
    'app_2': 'Chicken Fingers.jpg',
    'chn_1': 'YangChow.jpg',
    'chn_2': 'Crab and Corn Soup.jpg',
    'des_1': 'Lava Cake.jpg',
    'des_2': 'Halo Halo.jpg',
    'drk_1': 'Cucumber Lemonade.jpg',
    'fil_1': 'Crispy Sisig.jpg',
    'fil_2': 'Beef Kare Kare.jpg',
    'fil_3': 'Bulalo.jpg',
  };

  // Map dish name keywords to exact local asset filenames in Externalasset/
  static String? getLocalAssetPath(String name, String id) {
    if (docIdToFilename.containsKey(id)) {
      return 'Externalasset/${docIdToFilename[id]}';
    }

    final lowerName = name.toLowerCase().trim();

    if (lowerName.contains('aglio olio')) return 'Externalasset/AGLIO OLIO (SHRIMP, ANCHOVIES, SEAFOOD).jpg';
    if (lowerName.contains('all meat')) return 'Externalasset/ALL MEAT PIZZA.jpg';
    if (lowerName.contains('arrab') || lowerName.contains('arrabi')) return 'Externalasset/ARRABIATTA PASTA.jpg';
    if (lowerName.contains('mozarella') || lowerName.contains('mozzarella')) return 'Externalasset/Aramielle Mozarella.jpg';
    if (lowerName.contains('aramielle salad')) return 'Externalasset/Aramielle Salad';
    if (lowerName.contains('baked penne')) return 'Externalasset/BAKED PENNE.jpg';
    if (lowerName.contains('beef mushroom') && !lowerName.contains('creamy')) return 'Externalasset/BEEF MUSHROOM.jpg';
    if (lowerName.contains('barbeque wings') || lowerName.contains('bbq wings')) return 'Externalasset/Barbeque Wings.jpg';
    if (lowerName.contains('batangas lomi') || lowerName.contains('lomi')) return 'Externalasset/Batangas Lomi.jpg';
    if (lowerName.contains('beef broccoli')) return 'Externalasset/Beef Broccoli.jpg';
    if (lowerName.contains('cadereta') || lowerName.contains('caldereta')) return 'Externalasset/Beef Cadereta.jpg';
    if (lowerName.contains('kare kare') && lowerName.contains('beef')) return 'Externalasset/Beef Kare Kare.jpg';
    if (lowerName.contains('buffalo wings')) return 'Externalasset/Buffalo Wings.jpg';
    if (lowerName.contains('family bulalo')) return 'Externalasset/Family Bulalo.jpg';
    if (lowerName.contains('sizzling bulalo')) return 'Externalasset/Sizzling Bulalo.jpg';
    if (lowerName.contains('bulalo')) return 'Externalasset/Bulalo.jpg';
    if (lowerName.contains('carbonara')) return 'Externalasset/CARBONARA.jpg';
    if (lowerName.contains('chicken alfredo')) return 'Externalasset/CHICKEN ALFREDO.jpg';
    if (lowerName.contains('caesar salad')) return 'Externalasset/Caesar Salad.jpg';
    if (lowerName.contains('calamari salad')) return 'Externalasset/Calamari Salad.jpg';
    if (lowerName.contains('canton bihon')) return 'Externalasset/Canton Bihon.jpg';
    if (lowerName.contains('canton sotanghon')) return 'Externalasset/Canton Sotanghon.jpg';
    if (lowerName.contains('chicken fingers')) return 'Externalasset/Chicken Fingers.jpg';
    if (lowerName.contains('crab and corn')) return 'Externalasset/Crab and Corn Soup.jpg';
    if (lowerName.contains('creamy beef mushroom')) return 'Externalasset/Creamy Beef Mushroom.jpg';
    if (lowerName.contains('sisig') && lowerName.contains('crispy')) return 'Externalasset/Crispy Sisig.jpg';
    if (lowerName.contains('dinakdakan')) return 'Externalasset/Dinakdakan.jpg';
    if (lowerName.contains('fish and chips')) return 'Externalasset/Fish and Chips.jpg';
    if (lowerName.contains('hawaiian')) return 'Externalasset/HAWAIIAN.jpg';
    if (lowerName.contains('honey buttered')) return 'Externalasset/Honey Buttered Wings.jpg';
    if (lowerName.contains('hototay')) return 'Externalasset/Hototay Soup.jpg';
    if (lowerName.contains('kani')) return 'Externalasset/Kani salad.jpg';
    if (lowerName.contains('margherita')) return 'Externalasset/MARGHERITA.jpg';
    if (lowerName.contains('nachos')) return 'Externalasset/Nachos.jpg';
    if (lowerName.contains('pasta negra')) return 'Externalasset/PASTA NEGRA.jpg';
    if (lowerName.contains('pepperoni')) return 'Externalasset/PEPPERONI pizza.jpg';
    if (lowerName.contains('pancit canton')) return 'Externalasset/Pancit Canton.jpg';
    if (lowerName.contains('bihon')) return 'Externalasset/Pansit Bihon.jpg';
    if (lowerName.contains('parmesan wings')) return 'Externalasset/Parmesan Wings.jpg';
    if (lowerName.contains('quattro')) return 'Externalasset/QUATTRO FORMAGGI.jpg';
    if (lowerName.contains('quesadilla')) return 'Externalasset/Quesadilla.jpg';
    if (lowerName.contains('rib eye') || lowerName.contains('ribeye')) return 'Externalasset/Ribeye steak with mashed potato.jpg';
    if (lowerName.contains('roast beef')) return 'Externalasset/Roast Beef.jpg';
    if (lowerName.contains('spicy rigat')) return 'Externalasset/SPICY RIGATTONI.jpg';
    if (lowerName.contains('seafood pesto')) return 'Externalasset/Seafood Pesto.png';
    if (lowerName.contains('bangus sisig')) return 'Externalasset/Sizzling Bangus Sisig.jpg';
    if (lowerName.contains('spicy squid')) return 'Externalasset/Sizzling Spicy Squid.jpg';
    if (lowerName.contains('sizzling tofu')) return 'Externalasset/Sizzling Tofu.jpg';
    if (lowerName.contains('sotanghon')) return 'Externalasset/Sotanghon.jpg';
    if (lowerName.contains('spicy garlic wings')) return 'Externalasset/Spicy Garlic Wings.jpg';
    if (lowerName.contains('sweet and spicy canton')) return 'Externalasset/Sweet and Spicy Canton.jpg';
    if (lowerName.contains('t-bone') || lowerName.contains('t- bone')) return 'Externalasset/T- bone steak.jpg';
    if (lowerName.contains('truffle')) return 'Externalasset/TRUFFLE PASTA.jpg';
    if (lowerName.contains('terriyaki') || lowerName.contains('teriyaki')) return 'Externalasset/Terriyaki Wing.jpg';
    if (lowerName.contains('tokwa')) return 'Externalasset/Tokwa\'t Baboy.jpg';
    if (lowerName.contains('salmon steak')) return 'Externalasset/grilled salmon steak.jpg';
    if (lowerName.contains('aramielle')) return 'Externalasset/ARAMIELLE.png';

    return null;
  }
}
