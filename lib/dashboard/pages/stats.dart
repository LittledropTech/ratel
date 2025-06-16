import 'package:bitsure/utils/customutils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coingecko_api/coingecko_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

import '../../gen/assets.gen.dart';
import '../../utils/theme.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});
  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final CoinGeckoApi api = CoinGeckoApi();
  double? priceUSD;
  double? change24h;
  List<double>? dataPoints;
  String selectedRange = '1M';

  @override
  void initState() {
    super.initState();
    fetchStats();
    fetchChart();
  }

  void _launchURL(BuildContext context, url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  Future<void> printCurrentBtcPrice() async {
    final api = CoinGeckoApi();

    // Fetch OHLC for the last 1 day (24 h) on BTC/USD
    final result = await api.coins.getCoinOHLC(
      id: 'bitcoin',
      vsCurrency: 'usd',
      days: 1,
    );

    if (result.isError) {
      print('Error fetching OHLC: ${result.errorMessage}');
      return;
    }

    // `result.data` is a List<MarketChartOHLC>
    final ohlc = result.data;
    if (ohlc.isEmpty) {
      print('No OHLC data returned.');
      return;
    }

    // The last element’s `close` is effectively "most recent" price
    final latest = ohlc.last;
    print('As of ${latest.timestamp}:');
    print('  Open:  ${latest.open}');
    print('  High:  ${latest.high}');
    print('  Low:   ${latest.low}');
    print('> Close: ${latest.close}  ← current price');

    setState(() {
      priceUSD = latest.close;
    });
  }

  Future<void> fetchStats() async {
    printCurrentBtcPrice();
    final result = await api.coins.getCoinData(
      id: 'bitcoin',
      localization: false,
      tickers: false,
      marketData: true,
      communityData: false,
      developerData: false,
      sparkline: false,
    );

    if (!result.isError &&
        result.data != null &&
        result.data!.marketData != null) {
      final market = result.data!.marketData!;
      setState(() {
        // priceUSD = (market['info'] as num).toDouble();

        change24h = market.priceChangePercentage24h?.toDouble();
      });
    }
  }

  Future<void> fetchChart() async {
    final int days = selectedRange == '1M' ? 30 : 7;
    final res = await api.coins.getCoinMarketChart(
      id: 'bitcoin',
      vsCurrency: 'usd',
      days: days,
    );

    if (!res.isError && res.data.isNotEmpty) {
      setState(() {
        dataPoints = res.data.map((entry) => entry.price!.toDouble()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.quicksand(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kwhitecolor,
        elevation: 0,
        title: Text("Stats", style: titleStyle.copyWith(fontSize: 24)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(Assets.images.bitcoinStats.path),
            ),
            const SizedBox(height: 12),
            Text(
              'Bitcoin',
              style: GoogleFonts.quicksand(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (priceUSD != null && change24h != null)
              Text(
                '\$${formatNumber(priceUSD)}  '
                '${change24h! >= 0 ? '+' : ''}${change24h!.toStringAsFixed(2)}%',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: change24h! >= 0 ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(height: 24),
            if (dataPoints != null)
              SizedBox(
                height: 180,
                child: CustomPaint(
                  painter: _LinePainter(data: dataPoints!, color: Colors.amber),
                  child: Container(),
                ),
              )
            else
              const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '“Bag go boom / Bag go ouch”',
                  style: GoogleFonts.quicksand(fontSize: 14),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(Assets.meme1.path),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: ['1D', '1W', '1M', '1Y', 'ALL'].map((r) {
                final bool sel = r == selectedRange;
                return Container(
                  height: 36,
                  // 1) Mirror your container’s decoration:
                  decoration: BoxDecoration(
                    color: sel ? Colors.amber[200] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedRange = r;
                        fetchChart();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      // 2) Make the button itself transparent and flat:
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      r,
                      style: GoogleFonts.quicksand(
                        color: sel ? Colors.black : Colors.grey[700],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Wrap(
            //   spacing: 8,
            //   children: ['1D', '1W', '1M', '1Y', 'ALL'].map((r) {
            //     final bool sel = r == selectedRange;
            //     return ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           selectedRange = r;
            //           fetchChart();
            //         });
            //       },
            //       style: ElevatedButton.styleFrom(
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(8)),
            //         backgroundColor:
            //             sel ? Colors.amber[200] : Colors.grey[200],
            //         elevation: 4,
            //         shadowColor: Colors.black87,
            //       ),
            //       child: Text(r,
            //           style: GoogleFonts.quicksand(
            //               color: sel ? Colors.black : Colors.grey[700])),
            //     );
            //   }).toList(),
            // ),
            const SizedBox(height: 32),
            GestureDetector(
              // onTap: () => printCurrentBtcPrice(),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black87, offset: Offset(4, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "A lil bit about BTC",
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Bitcoin is a cryptocurrency.",
                          style: GoogleFonts.quicksand(fontSize: 14),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle read more action
                        _launchURL(
                          context,
                          'https://youtu.be/8Z4hGvUET8I?si=tHUFjIA09exAChOs',
                        );
                      },
                      child: Text(
                        'Read more',
                        style: GoogleFonts.quicksand(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  _LinePainter({required this.data, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final minVal = data.reduce(min);
    final maxVal = data.reduce(max);
    final scaleY = (size.height) / (maxVal - minVal);
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      double x = size.width * (i / (data.length - 1));
      double y = size.height - (data[i] - minVal) * scaleY;
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.data != data || old.color != color;
}
