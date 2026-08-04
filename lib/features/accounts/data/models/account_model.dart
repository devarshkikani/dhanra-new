import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    required super.id,
    required super.name,
    required super.type,
    required super.balance,
    required super.currency,
    required super.colorHex,
    required super.iconName,
    super.accountNumberLast4,
    super.creditLimit,
    super.isActive = true,
    super.createdAt,
  });

  factory AccountModel.fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      balance: entity.balance,
      currency: entity.currency,
      colorHex: entity.colorHex,
      iconName: entity.iconName,
      accountNumberLast4: entity.accountNumberLast4,
      creditLimit: entity.creditLimit,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: AccountType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? 'bank'),
        orElse: () => AccountType.bank,
      ),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
      colorHex: json['colorHex'] as String? ?? '#9B5DE5',
      iconName: json['iconName'] as String? ?? 'account_balance',
      accountNumberLast4: json['accountNumberLast4'] as String?,
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'balance': balance,
      'currency': currency,
      'colorHex': colorHex,
      'iconName': iconName,
      'accountNumberLast4': accountNumberLast4,
      'creditLimit': creditLimit,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
