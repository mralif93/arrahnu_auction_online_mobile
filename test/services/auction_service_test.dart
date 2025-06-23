import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


import 'package:arrahnu_auction_online_mobile/services/auction_service.dart';
import 'package:arrahnu_auction_online_mobile/services/api_service.dart';

// Mock ApiService for testing
class MockApiService extends Mock implements ApiService {}

void main() {
  group('Auction Service Models Tests', () {
    group('ActiveAuctionsResponse', () {
      test('should create ActiveAuctionsResponse from JSON correctly', () {
        final mockResponseData = {
          'data': {
            'auctions': [
              {
                'id': 'auction-001',
                'title': 'Gold Jewelry Auction',
                'description': 'Premium gold jewelry collection',
                'status': 'active',
                'start_date': '2024-01-01T10:00:00Z',
                'end_date': '2024-01-01T18:00:00Z',
                'collaterals_count': 5,
                'total_bids': 25,
                'featured_collateral': {
                  'id': 'collateral-001',
                  'title': 'Diamond Ring',
                  'image_url': 'https://example.com/ring.jpg',
                  'estimated_value': 5000.0,
                  'current_highest_bid': 5200.0
                }
              }
            ],
            'pagination': {
              'current_page': 1,
              'per_page': 20,
              'total': 1,
              'last_page': 1
            }
          }
        };

        final auctionsResponse = ActiveAuctionsResponse.fromJson(mockResponseData);

        expect(auctionsResponse.auctions.length, 1);
        
        final auction = auctionsResponse.auctions.first;
        expect(auction.id, 'auction-001');
        expect(auction.title, 'Gold Jewelry Auction');
        expect(auction.description, 'Premium gold jewelry collection');
        expect(auction.status, 'active');
        expect(auction.startDate, '2024-01-01T10:00:00Z');
        expect(auction.endDate, '2024-01-01T18:00:00Z');
        expect(auction.collateralsCount, 5);
        expect(auction.totalBids, 25);
        
        expect(auction.featuredCollateral, isNotNull);
        expect(auction.featuredCollateral!.id, 'collateral-001');
        expect(auction.featuredCollateral!.title, 'Diamond Ring');
        expect(auction.featuredCollateral!.estimatedValue, 5000.0);
        expect(auction.featuredCollateral!.currentHighestBid, 5200.0);
        
        expect(auctionsResponse.pagination.currentPage, 1);
        expect(auctionsResponse.pagination.total, 1);
      });

      test('should handle empty auctions list', () {
        final mockResponseData = {
          'data': {
            'auctions': [],
            'pagination': {
              'current_page': 1,
              'per_page': 20,
              'total': 0,
              'last_page': 1
            }
          }
        };

        final auctionsResponse = ActiveAuctionsResponse.fromJson(mockResponseData);

        expect(auctionsResponse.auctions, isEmpty);
        expect(auctionsResponse.pagination.total, 0);
      });
    });

    group('AuctionItem', () {
      test('should create AuctionItem from JSON correctly', () {
        final auctionJson = {
          'id': 'auction-123',
          'title': 'Electronics Auction',
          'description': 'Vintage electronics collection',
          'status': 'active',
          'start_date': '2024-01-15T09:00:00Z',
          'end_date': '2024-01-15T17:00:00Z',
          'collaterals_count': 3,
          'total_bids': 12,
        };

        final auctionItem = AuctionItem.fromJson(auctionJson);

        expect(auctionItem.id, 'auction-123');
        expect(auctionItem.title, 'Electronics Auction');
        expect(auctionItem.description, 'Vintage electronics collection');
        expect(auctionItem.status, 'active');
        expect(auctionItem.startDate, '2024-01-15T09:00:00Z');
        expect(auctionItem.endDate, '2024-01-15T17:00:00Z');
        expect(auctionItem.collateralsCount, 3);
        expect(auctionItem.totalBids, 12);
        expect(auctionItem.featuredCollateral, null);
      });

      test('should handle missing optional fields', () {
        final minimalAuctionJson = {
          'id': 'auction-minimal',
          'title': '',
          'description': '',
          'status': '',
          'start_date': '',
          'end_date': '',
        };

        final auctionItem = AuctionItem.fromJson(minimalAuctionJson);

        expect(auctionItem.id, 'auction-minimal');
        expect(auctionItem.title, '');
        expect(auctionItem.collateralsCount, 0);
        expect(auctionItem.totalBids, 0);
        expect(auctionItem.featuredCollateral, null);
      });
    });

    group('BidResponse', () {
      test('should create BidResponse from JSON correctly', () {
        final mockBidData = {
          'data': {
            'bid': {
              'id': 'bid-uuid-123',
              'amount': 2600.0,
              'status': 'active',
              'is_winning': true,
              'created_at': '2024-01-01T12:00:00Z'
            },
            'collateral': {
              'current_highest_bid': 2600.0,
              'total_bids': 5
            }
          }
        };

        final bidResponse = BidResponse.fromJson(mockBidData);

        expect(bidResponse.bid.id, 'bid-uuid-123');
        expect(bidResponse.bid.amount, 2600.0);
        expect(bidResponse.bid.status, 'active');
        expect(bidResponse.bid.isWinning, true);
        expect(bidResponse.bid.createdAt, '2024-01-01T12:00:00Z');
        
        expect(bidResponse.collateral.currentHighestBid, 2600.0);
        expect(bidResponse.collateral.totalBids, 5);
      });

      test('should handle unsuccessful bid response', () {
        final mockBidData = {
          'data': {
            'bid': {
              'id': 'bid-uuid-456',
              'amount': 2500.0,
              'status': 'outbid',
              'is_winning': false,
              'created_at': '2024-01-01T11:30:00Z'
            },
            'collateral': {
              'current_highest_bid': 2600.0,
              'total_bids': 6
            }
          }
        };

        final bidResponse = BidResponse.fromJson(mockBidData);

        expect(bidResponse.bid.amount, 2500.0);
        expect(bidResponse.bid.status, 'outbid');
        expect(bidResponse.bid.isWinning, false);
        expect(bidResponse.collateral.currentHighestBid, 2600.0);
        expect(bidResponse.collateral.totalBids, 6);
      });
    });

    group('UserBid', () {
      test('should create UserBid from JSON correctly', () {
        final bidJson = {
          'id': 'bid-789',
          'amount': 1500.0,
          'status': 'active',
          'is_winning': true,
          'created_at': '2024-01-01T10:30:00Z',
          'collateral': {
            'id': 'collateral-456',
            'title': 'Gold Necklace',
            'image_url': 'https://example.com/necklace.jpg'
          },
                     'auction': {
             'id': 'auction-789',
             'status': 'active',
             'start_date': '2024-01-01T09:00:00Z',
             'end_date': '2024-01-01T18:00:00Z',
             'time_remaining': 3600
           }
        };

        final userBid = UserBid.fromJson(bidJson);

        expect(userBid.id, 'bid-789');
        expect(userBid.amount, 1500.0);
        expect(userBid.status, 'active');
        expect(userBid.isWinning, true);
        expect(userBid.createdAt, '2024-01-01T10:30:00Z');
        
        // Test convenience getters
        expect(userBid.bidAmount, 1500.0);
        expect(userBid.auctionTitle, 'Gold Necklace');
        expect(userBid.bidTime, '2024-01-01T10:30:00Z');
        expect(userBid.auctionId, 'auction-789');
        
        expect(userBid.collateral, isNotNull);
        expect(userBid.collateral!.id, 'collateral-456');
        expect(userBid.collateral!.title, 'Gold Necklace');
        
                 expect(userBid.auction, isNotNull);
         expect(userBid.auction!.id, 'auction-789');
         expect(userBid.auction!.status, 'active');
      });

      test('should handle UserBid without collateral and auction info', () {
        final minimalBidJson = {
          'id': 'bid-minimal',
          'amount': 1000.0,
          'status': 'active',
          'is_winning': false,
          'created_at': '2024-01-01T08:00:00Z'
        };

        final userBid = UserBid.fromJson(minimalBidJson);

        expect(userBid.id, 'bid-minimal');
        expect(userBid.amount, 1000.0);
        expect(userBid.collateral, null);
        expect(userBid.auction, null);
        expect(userBid.auctionTitle, 'Unknown Auction');
        expect(userBid.auctionId, '');
      });
    });

    group('PaginationInfo', () {
      test('should create PaginationInfo from JSON correctly', () {
        final paginationJson = {
          'current_page': 2,
          'per_page': 15,
          'total': 100,
          'last_page': 7
        };

        final pagination = PaginationInfo.fromJson(paginationJson);

        expect(pagination.currentPage, 2);
        expect(pagination.perPage, 15);
        expect(pagination.total, 100);
        expect(pagination.lastPage, 7);
      });

      test('should handle empty pagination info', () {
        final emptyPagination = PaginationInfo.fromJson({});

        expect(emptyPagination.currentPage, 1);
        expect(emptyPagination.perPage, 20);
        expect(emptyPagination.total, 0);
        expect(emptyPagination.lastPage, 1);
      });
    });

    group('BiddingHistoryResponse', () {
      test('should create BiddingHistoryResponse from JSON correctly', () {
        final mockHistoryData = {
          'data': {
            'bids': [
              {
                'id': 'bid-history-1',
                'amount': 2000.0,
                'status': 'won',
                'is_winning': false,
                'created_at': '2024-01-01T14:00:00Z'
              },
              {
                'id': 'bid-history-2',
                'amount': 1800.0,
                'status': 'outbid',
                'is_winning': false,
                'created_at': '2024-01-01T13:00:00Z'
              }
            ],
            'pagination': {
              'current_page': 1,
              'per_page': 20,
              'total': 2,
              'last_page': 1
            },
            'statistics': {
              'total_bids': 15,
              'active_bids': 3,
              'winning_bids': 1
            }
          }
        };

        final historyResponse = BiddingHistoryResponse.fromJson(mockHistoryData);

        expect(historyResponse.bids.length, 2);
        expect(historyResponse.bids.first.id, 'bid-history-1');
        expect(historyResponse.bids.first.amount, 2000.0);
        expect(historyResponse.bids.first.status, 'won');
        
        expect(historyResponse.pagination.total, 2);
        expect(historyResponse.statistics.totalBids, 15);
        expect(historyResponse.statistics.activeBids, 3);
        expect(historyResponse.statistics.winningBids, 1);
      });
    });

    group('API Response Error Handling', () {
      test('should handle auction fetch errors', () {
        final errorResponse = ApiResponse<ActiveAuctionsResponse>.error('Failed to fetch auctions');
        expect(errorResponse.isSuccess, false);
        expect(errorResponse.error, 'Failed to fetch auctions');
        expect(errorResponse.data, null);
      });

      test('should handle bid placement errors', () {
        final bidError = ApiResponse<BidResponse>.error('Insufficient funds');
        expect(bidError.isSuccess, false);
        expect(bidError.error, 'Insufficient funds');
      });

      test('should handle network errors', () {
        final networkError = ApiResponse<ActiveAuctionsResponse>.error('No internet connection');
        expect(networkError.isSuccess, false);
        expect(networkError.error, 'No internet connection');
      });
    });

    group('Data Validation', () {
      test('should validate bid amounts', () {
        final validBid = UserBid(
          id: 'bid-valid',
          amount: 1500.0,
          status: 'active',
          isWinning: true,
          createdAt: '2024-01-01T12:00:00Z',
        );

        expect(validBid.amount, greaterThan(0));
        expect(validBid.amount, 1500.0);
      });

      test('should validate auction status', () {
        final activeAuction = AuctionItem(
          id: 'auction-active',
          title: 'Active Auction',
          description: 'Test auction',
          status: 'active',
          startDate: '2024-01-01T09:00:00Z',
          endDate: '2024-01-01T18:00:00Z',
          collateralsCount: 5,
          totalBids: 10,
        );

        expect(activeAuction.status, 'active');
        expect(activeAuction.collateralsCount, greaterThan(0));
        expect(activeAuction.totalBids, greaterThanOrEqualTo(0));
      });

      test('should validate pagination bounds', () {
        final pagination = PaginationInfo(
          currentPage: 2,
          perPage: 20,
          total: 100,
          lastPage: 5,
        );

        expect(pagination.currentPage, greaterThan(0));
        expect(pagination.currentPage, lessThanOrEqualTo(pagination.lastPage));
        expect(pagination.perPage, greaterThan(0));
        expect(pagination.total, greaterThanOrEqualTo(0));
      });
    });

    group('Integration Tests', () {
      test('should handle complete auction flow', () {
        // Mock auction data
        final auctionData = {
          'data': {
            'auctions': [
              {
                'id': 'auction-integration',
                'title': 'Integration Test Auction',
                'description': 'Test auction for integration',
                'status': 'active',
                'start_date': '2024-01-01T09:00:00Z',
                'end_date': '2024-01-01T18:00:00Z',
                'collaterals_count': 1,
                'total_bids': 0,
              }
            ],
            'pagination': {
              'current_page': 1,
              'per_page': 20,
              'total': 1,
              'last_page': 1
            }
          }
        };

        final auctionsResponse = ActiveAuctionsResponse.fromJson(auctionData);
        final auction = auctionsResponse.auctions.first;

        expect(auction.id, 'auction-integration');
        expect(auction.status, 'active');

        // Mock bid placement
        final bidData = {
          'data': {
            'bid': {
              'id': 'bid-integration',
              'amount': 1000.0,
              'status': 'active',
              'is_winning': true,
              'created_at': '2024-01-01T12:00:00Z'
            },
            'collateral': {
              'current_highest_bid': 1000.0,
              'total_bids': 1
            }
          }
        };

        final bidResponse = BidResponse.fromJson(bidData);
        
        expect(bidResponse.bid.amount, 1000.0);
        expect(bidResponse.bid.isWinning, true);
        expect(bidResponse.collateral.totalBids, 1);
      });
    });
  });
} 