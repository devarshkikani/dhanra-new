import 'package:equatable/equatable.dart';

enum AccountType {
  bank,
  wallet,
  cash,
  creditCard,
}

extension AccountTypeX on AccountType {
  String get displayName {
    switch (this) {
      case AccountType.bank:
        return 'Bank Account';
      case AccountType.wallet:
        return 'Digital Wallet';
      case AccountType.cash:
        return 'Cash';
      case AccountType.creditCard:
        return 'Credit Card';
    }
  }
}

class AccountEntity extends Equatable {
  const AccountEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    required this.colorHex,
    required this.iconName,
    this.accountNumberLast4,
    this.creditLimit,
    this.isActive = true,
    this.createdAt,
  });

  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String currency;
  final String colorHex;
  final String iconName;
  final String? accountNumberLast4;
  final double? creditLimit;
  final bool isActive;
  final DateTime? createdAt;

  AccountEntity copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? balance,
    String? currency,
    String? colorHex,
    String? iconName,
    String? accountNumberLast4,
    double? creditLimit,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      colorHex: colorHex ?? this.colorHex,
      iconName: iconName ?? this.iconName,
      accountNumberLast4: accountNumberLast4 ?? this.accountNumberLast4,
      creditLimit: creditLimit ?? this.creditLimit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        balance,
        currency,
        colorHex,
        iconName,
        accountNumberLast4,
        creditLimit,
        isActive,
        createdAt,
      ];
}
