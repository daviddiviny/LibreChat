const { getBalanceConfig } = require('@librechat/api');
const { Balance } = require('~/db/models');
const { getAppConfig } = require('~/server/services/Config');

async function balanceController(req, res) {
  let balanceData = await Balance.findOne(
    { user: req.user.id },
    {
      tokenCredits: 1,
      refillIntervalUnit: 1,
      refillIntervalValue: 1,
      lastRefill: 1,
      refillAmount: 1,
      autoRefillEnabled: 1,
    },
  ).lean();

  if (!balanceData) {
    const appConfig = await getAppConfig();
    const balanceConfig = getBalanceConfig(appConfig);

    if (balanceConfig?.enabled) {
      const update = {
        $setOnInsert: {
          user: req.user.id,
          tokenCredits: balanceConfig.startBalance || 0,
        },
      };

      if (
        balanceConfig.autoRefillEnabled &&
        balanceConfig.refillIntervalValue != null &&
        balanceConfig.refillIntervalUnit != null &&
        balanceConfig.refillAmount != null
      ) {
        update.$setOnInsert = {
          ...update.$setOnInsert,
          autoRefillEnabled: true,
          refillIntervalValue: balanceConfig.refillIntervalValue,
          refillIntervalUnit: balanceConfig.refillIntervalUnit,
          refillAmount: balanceConfig.refillAmount,
        };
      }

      balanceData = await Balance.findOneAndUpdate({ user: req.user.id }, update, {
        upsert: true,
        new: true,
        projection: {
          tokenCredits: 1,
          refillIntervalUnit: 1,
          refillIntervalValue: 1,
          lastRefill: 1,
          refillAmount: 1,
          autoRefillEnabled: 1,
        },
      }).lean();
    }
  }

  if (!balanceData) {
    return res.status(404).json({ error: 'Balance not found' });
  }

  if (!balanceData.autoRefillEnabled) {
    delete balanceData.refillIntervalValue;
    delete balanceData.refillIntervalUnit;
    delete balanceData.lastRefill;
    delete balanceData.refillAmount;
  }

  res.status(200).json(balanceData);
}

module.exports = balanceController;
