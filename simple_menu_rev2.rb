# Reads from a library of code called 'input_functions.rb'. Used for defining code such as 'read_string'
require './input_functions'

# Creates a module to define what is considered a 'Genre'
module Genre
    POP, CLASSIC, JAZZ, ROCK = *1..4 # Sets the amount of genres from 1 - 4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

# Creates a class called 'Album' to store data
class Album
    attr_accessor :title, :artist, :genre, :tracks, :label

    def initialize(title, artist, genre, tracks, label)
        @title = title
        @artist = artist
        @genre = genre
        @tracks = tracks
        @label = label
    end
end

# Creates a class called 'Track' to store data
class Track
    attr_accessor :name, :location, :duration

    def initialize(name, location, duration)
        @name = name
        @location = location
        @duration = duration
    end
end

def print_separator
    puts "--------------------------------"  # Add a separator for clarity
end

# Reads in and returns a single track from the given file
def read_track(music_file)
    track_name = music_file.gets
    track_location = music_file.gets
    track_duration = music_file.gets
    Track.new(track_name, track_location, track_duration)
end

# Returns an array of tracks read from the given file
def read_tracks(music_file, track_count)
    tracks = []
    index = 0
    while index < track_count
        track_title = music_file.gets.chomp
        track_file = music_file.gets.chomp
        duration = music_file.gets.chomp
        tracks << Track.new(track_title, track_file, duration)
        index += 1
    end
    tracks
end

# Takes an array of tracks and prints them to the terminal
def print_tracks(tracks)
    index = 0
    while index < tracks.length
        print_track(tracks[index])
        index += 1
    end
end

# Takes a single track and prints it to the terminal
def print_track(track)
    puts "Track Name: #{track.name} | Location: #{track.location} | Duration: #{track.duration}"
end

# Prints a single album along with its tracks
def print_album(album)
    puts "Album: #{album.title}, Artist: #{album.artist}, Genre: #{GENRE_NAMES[album.genre]}, Label: #{album.label}"
    print_tracks(album.tracks)
end

# Displays the albums interface
def display_albums(albums)
    finished = false
    until finished
        puts 'Display Albums Menu:'
        puts '1. Display All Albums'
        puts '2. Display Albums by Genre'
        puts '3. Return to Main Menu'
        choice = read_integer_in_range("Please enter your choice:", 1, 3)
        case choice
        when 1
            print_separator
            display_all_albums(albums)
        when 2
            print_separator
            display_albums_genre(albums)
        when 3
            print_separator
            finished = true
        else
            puts "Please select again."
        end
    end
end

# Displays all albums from file
def display_all_albums(albums)
    read_string("You selected Display All Albums. Press enter to continue")
    if albums.length == 0
        puts "No albums available. Ensure you Read in Albums first."
        print_separator
        return
    end
    index = 0
    while index < albums.length
        print_album(albums[index])
        print_separator
        index += 1
    end
end

# Asks for genre to be selected 
def display_genre_options
    index = 1
    while index < GENRE_NAMES.length    
        puts "#{index}. #{GENRE_NAMES[index]}"
        index += 1
    end
end

# Displays genres to select (eg. Pop, Classic, Jazz, Rock)
def display_albums_genre(albums)
    display_genre_options
    genre_choice = read_integer_in_range("Please select a genre:", 1, GENRE_NAMES.length - 1)
    print_separator
    filtered_albums = []
    index = 0

    while index < albums.length
        if albums[index].genre == genre_choice
            filtered_albums << albums[index]
        end
        index += 1
    end
    # Checks if album exists within selected genre 
    if filtered_albums.length == 0 
        puts "No albums found for the selected genre."
    else
        puts "Albums in the selected genre:"
        index = 0
        while index < filtered_albums.length
            print_album(filtered_albums[index])
            index += 1
            print_separator
        end
    end
end

# Validates if the correct format for the duration is entered
def read_track_duration(prompt)
    finished = false
    until finished
        duration = read_string(prompt)
        if duration =~ /^\d{1,2}:\d{2}$/ # Checks if minutes match to M or MM and seconds match to SS (eg. 3:30 or 03:30)
            minutes, seconds = duration.split(':').map(&:to_i)
            # Check if the duration exceeds 59:59
            if minutes < 60 and seconds < 60
                finished = true
                return duration
            else
                puts "Invalid duration. Minutes must be less than 60 and seconds must be less than 60."
            end
        else
            puts "Invalid format. Please enter the duration in M:SS or MM:SS format (e.g. 3:30 or 03:30)."
        end
    end
end

# Allows user to add a new album to pre-existing array
def add_album(albums)
    read_string("You selected 'Add an Album'. Press enter to continue")

    title = read_string("Enter title:")
    artist = read_string("Enter artist:")
    label = read_string("Enter label:")
    display_genre_options
    genre = read_integer_in_range("Enter number of genre:", 1, GENRE_NAMES.length - 1)

    track_count = read_integer_in_range("Enter number of tracks", 1, 15)
    tracks = []
    index = 0
    while index < track_count
        track_name = read_string("Enter a name for the new track:")
        track_location = read_string("Enter a location for the new track:")
        track_duration = read_track_duration("Enter track duration (e.g., 3:30 or 03:30):")

        tracks << Track.new(track_name, track_location, track_duration)
        index += 1
    end

    # Create a new Album instance and add it to the albums array
    albums << Album.new(title, artist, genre, tracks, label)

    puts "Album added: #{title}. Press enter to continue."
end

# Selecting the album to play from array
def select_album(albums)
    if albums.length == 0 # Checks if albums exist in the array
        puts "No albums available. Please Read in Albums first."
        return
    end

    read_string("You selected 'Select an Album to play'. Press enter to continue")
    # Displays albums from pre-existing array to select
    finished = false
    until finished
        puts "Select an album to play (or enter '0' to exit):"
        index = 0
        while index < albums.length
            puts "#{index + 1}: #{albums[index].title} by #{albums[index].artist}"
            index += 1
        end
        choice = gets.chomp
        if choice == '0'
            puts "Exiting album selection."
            finished = true
            next
        end
        # Displays current album being played
        choice = choice.to_i
        if choice >= 1 and choice <= albums.length
            selected_album = albums[choice - 1]
            puts "Playing: #{selected_album.title} by #{selected_album.artist}"

            current_track_index = 0

            track_finished = false
            until track_finished
                if selected_album.tracks.length > 0
                    current_track = selected_album.tracks[current_track_index]
                    puts "Now playing: #{current_track.name}"
                else
                    puts "This album has no tracks."
                    track_finished = true
                    next
                end
                puts "Options:"
                puts "1. Next Track"
                puts "2. Exit to Album Selection"

                option_choice = read_integer_in_range("Please choose an option:", 1, 2)

                case option_choice
                when 1
                    current_track_index += 1
                    if current_track_index >= selected_album.tracks.length
                        puts "You have reached the end of the album."
                        track_finished = true
                    end
                when 2
                    track_finished = true  # Exit back to album selection
                else
                    puts "Invalid option. Please choose again."
                end
            end
            puts "Press enter to continue"
            gets
        else
            puts "Invalid choice. Please select a valid album number or enter '0' to exit."
        end
    end
end

# Reads albums from file
def read_in_album(albums)
    read_string("You selected Read in Album. Press enter to continue")
    filename = read_string("Enter the filename to read albums from:")

    if File.exist?(filename)
        music_file = File.open(filename, "r")
            # Read the number of albums
            album_count = music_file.gets.to_i
            index = 0
            while index < album_count
                title = music_file.gets.chomp
                artist = music_file.gets.chomp
                genre = music_file.gets.to_i
                label = music_file.gets.chomp
                track_count = music_file.gets.to_i

                tracks = read_tracks(music_file, track_count)

                # Check for duplicate albums
                if albums.any? { |album| album.title == title and album.artist == artist }
                    puts "Album '#{title}' by '#{artist}' already exists. Skipping..."
                else
                    album = Album.new(title, artist, genre, tracks, label)
                    albums << album
                    puts "Album '#{title}' by '#{artist}' has been read successfully."
                end
                print_separator
                index += 1
            end
        else
            puts "Error: The file '#{filename}' could not be found. If filename is valid, ensure you add .txt at the end."
            print_separator
        end
    return albums
end

# Allows user to edit an existing album's title, artist, label, or genre
def edit_album(albums)
    read_string("You selected 'Edit an Album'. Press enter to continue")
    if albums.length == 0
        puts "No albums available. Please Read in Albums first."
        print_separator
        return
    end

    index = 0
    while index < albums.length
        puts "#{index + 1}: #{albums[index].title} by #{albums[index].artist}"
        index += 1
    end
    choice = read_integer_in_range("Select an album to edit:", 1, albums.length)
    album = albums[choice - 1]
    print_separator

    finished = false
    until finished
        puts "Editing: #{album.title} by #{album.artist}"
        puts '1. Edit Title'
        puts '2. Edit Artist'
        puts '3. Edit Label'
        puts '4. Edit Genre'
        puts '5. Done'
        edit_choice = read_integer_in_range("Please enter your choice:", 1, 5)
        case edit_choice
        when 1
            album.title = read_string("Enter new title (current: #{album.title}):")
        when 2
            album.artist = read_string("Enter new artist (current: #{album.artist}):")
        when 3
            album.label = read_string("Enter new label (current: #{album.label}):")
        when 4
            display_genre_options
            album.genre = read_integer_in_range("Enter new genre (current: #{GENRE_NAMES[album.genre]}):", 1, GENRE_NAMES.length - 1)
        when 5
            finished = true
        end
    end
    puts "Album updated: #{album.title} by #{album.artist}."
    print_separator
end

# Allows user to delete an existing album from array
def delete_album(albums)
    read_string("You selected 'Delete an Album'. Press enter to continue")
    if albums.length == 0
        puts "No albums available. Please Read in Albums first."
        print_separator
    end

    index = 0
    while index < albums.length
        puts "#{index + 1}: #{albums[index].title} by #{albums[index].artist}"
        index += 1
    end

choice = read_integer_in_range("Select an album to delete:", 1, albums.length)
    album = albums[choice - 1]
    print separator
    puts "Are you sure you want to delete '#{album.title}' by '#{album.artist}'? (yes/no)"
    confirm = gets.chomp.strip.downcase

    if confirm == "yes"
        albums.delete_at(choice - 1)
        puts "Album '#{album.title}' by '#{album.artist}' has been deleted successfully."
    else
        puts "Deletion cancelled. Album '#{album.title}' was not deleted."
    end
    print_separator
end

# Saves albums array to a file in the same format read_in_album expects
def save_albums(albums)
    read_string("You selected 'Save Albums'. Press enter to continue")
    if albums.length == 0
        puts "No albums to save."
        print_separator
        return
    end
    filename = read_string("Enter the filename to save albums to:")
    music_file = File.open(filename, "w")
    music_file.puts(albums.length)
    albums.each do |album|
        music_file.puts(album.title)
        music_file.puts(album.artist)
        music_file.puts(album.genre)
        music_file.puts(album.label)
        music_file.puts(album.tracks.length)
        album.tracks.each do |track|
            music_file.puts(track.name)
            music_file.puts(track.location)
            music_file.puts(track.duration)
        end
    end
    music_file.close
    puts "#{albums.length} album(s) saved to '#{filename}'."
    print_separator
end

# Main menu interface
def main
    albums = []
    finished = false
    until finished
        puts 'Main Menu:'
        puts '1. Read in Albums'
        puts '2. Display Albums'
        puts '3. Select an Album to play'
        puts '4. Add an Album'
        puts '5. Edit an Album'
        puts '6. Delete an Album'
        puts '7. Save Albums'
        puts '8. Exit the Application'
        choice = read_integer_in_range("Please enter your choice:", 1, 8)
        case choice
        when 1
            print_separator
            read_in_album(albums)
        when 2
            print_separator
            display_albums(albums)
        when 3
            print_separator
            select_album(albums)
        when 4
            print_separator
            add_album(albums)
        when 5
            print_separator
            edit_album(albums)
        when 6
            print_separator
            delete_album(albums)  
        when 7
            print_separator
            save_albums(albums)
        when 8
            finished = true
        else
            puts "Please select again"
        end
    end
end

main()
