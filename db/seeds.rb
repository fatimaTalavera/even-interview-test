# frozen_string_literal: true

require "faker"
Faker::UniqueGenerator.clear


puts "Clearing existing data..."

ArtistRelease.destroy_all
Release.destroy_all
Album.destroy_all
Artist.destroy_all

puts "Creating artists..."
artists = Array.new(20) { Artist.create!(name: Faker::Music.unique.band) }

puts "Creating albums and releases..."
releases = []

50.times do |i|
  primary_artist = artists.sample

  album = Album.create!(
    name: Faker::Music.unique.album,
    artist: primary_artist,
    duration_in_minutes: rand(30..90)
  )

  released_at =
    if i < 25
      Faker::Date.between(from: 5.years.ago.to_date, to: Date.today)
    else
      Faker::Date.between(from: Date.today, to: 2.years.from_now.to_date)
    end

  release = Release.create!(
    name: Faker::Music.album,
    released_at: released_at,
    album: album
  )

  releases << release

  ArtistRelease.create!(artist: primary_artist, release: release)

  next unless rand < 0.3

  featured_artist = (artists - [primary_artist]).sample
  ArtistRelease.create!(artist: featured_artist, release: release) if featured_artist
end

puts "\nSeed completed successfully!"
puts "Created #{Artist.count} artists"
puts "Created #{Album.count} albums"
puts "Created #{Release.count} releases"
puts "Created #{ArtistRelease.count} artist_releases"
