# Set the Ruby version
FROM ruby:3.4.1

# Install packages needed to build gems
RUN apt update -qq && \
    apt install -y build-essential libyaml-dev libpq-dev git pkg-config curl && \
    rm -rf /var/lib/apt/lists/*

# Rails app lives here
WORKDIR /edu-track

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy application code
COPY . .

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
