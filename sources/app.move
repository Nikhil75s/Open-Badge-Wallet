module MyModule::OpenBadgeWallet {
    use aptos_framework::signer;
    use std::vector;
    use std::string::String;
    
    /// Struct representing a badge wallet that stores credentials and NFT badges
    struct BadgeWallet has store, key {
        badges: vector<Badge>,           // Collection of badges/credentials
        total_badges: u64,               // Total number of badges earned
        owner: address,                  // Wallet owner address
    }
    
    /// Struct representing an individual badge or credential
    struct Badge has store, drop, copy {
        credential_id: u64,              // Unique ID for the credential
        badge_name: String,              // Name of the badge/credential
        issuer: address,                 // Address of badge issuer
        earned_timestamp: u64,           // When badge was earned
    }
    
    /// Function to initialize a new badge wallet for a user
    public fun create_wallet(owner: &signer) {
        let owner_addr = signer::address_of(owner);
        let wallet = BadgeWallet {
            badges: vector::empty<Badge>(),
            total_badges: 0,
            owner: owner_addr,
        };
        move_to(owner, wallet);
    }
    
    /// Function to award a badge/credential to a wallet holder
    public fun award_badge(
        issuer: &signer, 
        wallet_owner: address, 
        credential_id: u64,
        badge_name: String,
        timestamp: u64
    ) acquires BadgeWallet {
        let wallet = borrow_global_mut<BadgeWallet>(wallet_owner);
        let new_badge = Badge {
            credential_id,
            badge_name,
            issuer: signer::address_of(issuer),
            earned_timestamp: timestamp,
        };
        vector::push_back(&mut wallet.badges, new_badge);
        wallet.total_badges = wallet.total_badges + 1;
    }
}