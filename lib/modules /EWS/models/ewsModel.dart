class EarlyWarningSign {
  final double heartRate;
  final double oxygenSaturation;
  final double respiratoryRate;
  int _ewsScore = 0;

  EarlyWarningSign({
    required this.heartRate,
    required this.oxygenSaturation,
    required this.respiratoryRate,
  }) {
    _calculateEWS();
  }

  void _calculateEWS() {
    _ewsScore = 0;

    // Example threshold checks
    if (heartRate < 60 || heartRate > 100) {
      _ewsScore += 1;
    }
    if (oxygenSaturation < 95) {
      _ewsScore += 1;
    }
    if (respiratoryRate < 12 || respiratoryRate > 20) {
      _ewsScore += 1;
    }
  }

  int get ewsScore => _ewsScore;
}
