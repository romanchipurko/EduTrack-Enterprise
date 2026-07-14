# Set the Ruby version
FROM ruby:3.4.1

# Install packages needed to build gems
RUN apt update -qq && \
    apt install -y build-essential git curl pkg-config libpq-dev libyaml-dev && \
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
CMD ["bin/dev"]
