//
//  MockEventListRepresentable.swift
//  EventoriasTests
//
//  Created by KEITA on 29/12/2024.
//
import Foundation
@testable import Eventorias

class MockEventListRepresentable: EventListRepresentable {
    var shouldReturnError = false
          
          func getAllProducts() async throws -> [EventEntry] {
              if shouldReturnError {
                  throw NSError(domain: "TestError", code: 1, userInfo: nil)
              }
              
              return [
                  EventEntry(
                      picture: "Event 1",
                      title: "Annual Tech Conference",
                      dateCreation: Date(),
                      poster: "poster1.jpg",
                      description: "Event 1 Description",
                      hour: "10:00",
                      category: "Technology",
                      place: Address(
                          street: "123 Innovation Drive",
                          city: "Techville",
                          postalCode: "94016",
                          country: "USA",
                          localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348)
                      )
                  )
              ]
          }
          
          func getAllProductsSortedByCategory() async throws -> [EventEntry] {
              return [
                  EventEntry(
                      picture: "Event 2",
                      title: "Music Festival",
                      dateCreation: Date(),
                      poster: "poster2.jpg",
                      description: "Event 2 Description",
                      hour: "15:00",
                      category: "Music",
                      place: Address(
                          street: "456 Melody Lane",
                          city: "Harmonix",
                          postalCode: "12345",
                          country: "UK",
                          localisation: GeoPoint(latitude: 51.5074, longitude: -0.1278)
                      )
                  )
              ]
          }
          
          func getAllProductsSortedByDate() async throws -> [EventEntry] {
              return [
                  EventEntry(
                      picture: "Event 3",
                      title: "Sports Championship",
                      dateCreation: Date(),
                      poster: "poster3.jpg",
                      description: "Event 3 Description",
                      hour: "20:00",
                      category: "Sports",
                      place: Address(
                          street: "789 Sports Ave",
                          city: "Athletica",
                          postalCode: "54321",
                          country: "Canada",
                          localisation: GeoPoint(latitude: 45.4215, longitude: -75.6972)
                      )
                  )
              ]
          }
      }
