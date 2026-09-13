# Symfony Nginx PHP 8 Template 🚀

![Symfony](https://img.shields.io/badge/Symfony-7.2%2B-blue?style=flat-square) ![PHP](https://img.shields.io/badge/PHP-8.3-green?style=flat-square) ![Docker](https://img.shields.io/badge/Docker-Enabled-lightblue?style=flat-square) ![MySQL](https://img.shields.io/badge/MySQL-Enabled-orange?style=flat-square) ![Redis](https://img.shields.io/badge/Redis-Enabled-red?style=flat-square) ![ClickHouse](https://img.shields.io/badge/ClickHouse-Enabled-purple?style=flat-square)

Welcome to the **Symfony Nginx PHP 8 Template**! This repository offers a solid foundation for quickly starting Symfony projects using Docker, Nginx, and PHP 8.3. It also includes support for TailwindCSS, Xdebug, Redis, MySQL, and ClickHouse.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)
- [License](#license)
- [Releases](#releases)

## Features

- **Symfony 7.2+**: Build modern web applications with the latest features.
- **Docker Support**: Simplify your development environment with containerization.
- **Nginx**: Use a powerful web server for handling requests.
- **PHP 8.3**: Benefit from the latest PHP features and improvements.
- **TailwindCSS**: Easily style your applications with a utility-first CSS framework.
- **Xdebug**: Debug your applications efficiently.
- **Redis**: Utilize an in-memory data structure store for caching.
- **MySQL**: Use a reliable relational database for your data needs.
- **ClickHouse**: Integrate a fast columnar database for analytics.

## Getting Started

To get started with this template, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/alwynszz/symfony-nginx-php8.git
   cd symfony-nginx-php8
   ```

2. Build the Docker containers:

   ```bash
   docker-compose up -d
   ```

3. Access your application at `http://localhost`.

For detailed instructions, visit the [Releases](https://github.com/alwynszz/symfony-nginx-php8/releases) section.

## Usage

Once you have your environment set up, you can start building your Symfony application. Here are some common tasks:

### Running Migrations

To run database migrations, use the following command:

```bash
docker-compose exec php php bin/console doctrine:migrations:migrate
```

### Accessing the Symfony Console

To access the Symfony console, run:

```bash
docker-compose exec php php bin/console
```

### Building Assets

To build your assets with TailwindCSS, use:

```bash
docker-compose exec php npm run build
```

## Directory Structure

Here's a brief overview of the directory structure:

```
symfony-nginx-php8/
├── docker/
│   ├── nginx/
│   ├── php/
│   └── mysql/
├── src/
├── templates/
├── config/
├── public/
└── .env
```

- **docker/**: Contains Docker configuration files.
- **src/**: Your Symfony application source code.
- **templates/**: Twig templates for your views.
- **config/**: Configuration files for your application.
- **public/**: Public assets like images and stylesheets.
- **.env**: Environment variables for your application.

## Technologies Used

This template utilizes the following technologies:

- **Symfony**: A PHP framework for web applications.
- **Docker**: A platform for developing, shipping, and running applications in containers.
- **Nginx**: A high-performance web server.
- **PHP 8.3**: The latest version of PHP.
- **TailwindCSS**: A utility-first CSS framework for rapid UI development.
- **Xdebug**: A PHP extension for debugging.
- **Redis**: An in-memory data structure store.
- **MySQL**: A widely used relational database management system.
- **ClickHouse**: A fast columnar database for online analytical processing.

## Contributing

We welcome contributions to this project! If you have suggestions or improvements, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/YourFeature`).
6. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Releases

For the latest updates and versions, check the [Releases](https://github.com/alwynszz/symfony-nginx-php8/releases) section. Download and execute the files as needed to keep your project up to date.

## Conclusion

The **Symfony Nginx PHP 8 Template** provides a robust starting point for modern web development. With a focus on ease of use and powerful features, it helps you build applications efficiently. Explore the repository, and happy coding!