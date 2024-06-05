import 'dart:io';

class Constants{
  static String appName = "Base Project";
  static String dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

                                   /// Debug app IDs

  static String appOpenAD = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9257395921'
      : 'ca-app-pub-3940256099942544/5662855259';

  static String interstitialAD = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      // ? 'ca-app-pub-3940256099942544/5135589807'
      : 'ca-app-pub-3940256099942544/4411468910';

  static String adaptiveBannerAD = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String nativeAD = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  static String rewardedAD = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

}