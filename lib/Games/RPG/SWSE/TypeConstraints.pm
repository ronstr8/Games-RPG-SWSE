use Games::RPG::SWSE::TypeConstraints;

use Moose::Util::TypeConstraints;

enum 'SwseArmorGroup' => [qw( Light Medium Heavy )];

enum 'SwseWeaponGroup'       => [qw( AdvancedMelee Exotic Lightsaber Simple Unarmed Heavy Pistol Rifle Thrown )];
enum 'SwseWeaponDamageType'  => [qw( Slashing Piercing Bludgeoning Energy Ion Fire  )];
enum 'SwseWeaponFireRate'    => [qw( Single Auto )];

enum 'SwseSizeCLass'             => [qw( Fine Diminutive Tiny Small Medium Large Huge Gargantuan Colossal )];
enum 'SwseEquipmentAvailability' => [qw( Unrestricted Licensed Restricted Military Illegal Rare )];

no Moose::Util::TypeConstraints;

1;
