#!/usr/bin/perl

use strict;
use warnings;
use SDL;
use SDL::Events;
use SDL::Event;
use SDLx::App;
use SDLx::Rect;

my $app = SDLx::App->new(
    width => 800,
    height => 600,
    depth => 32,
    title => 'Pong Clone',
    exit_on_quit => 1
);

my $ballX = $app->w / 2;
my $ballY = $app->h / 2;
my $xVelocity = -13.5;
my $yVelocity = 9;

my $paddle1 = $app->h / 3;
my $paddle2 = $app->h / 3;
my $paddle1Velocity = 0;
my $paddle2Velocity = 0;

$app->add_event_handler(\&handle_events);

$app->add_move_handler(\&calculate_ball);
$app->add_move_handler(\&calculate_paddles);

$app->add_show_handler(\&render_ball);

$app->run();

sub handle_events
{
    my $event = shift;
    my $controller = shift;

    if($event->type == SDL_KEYDOWN)
    {
        if($event->key_sym == SDLK_w)    
        {
            $paddle1Velocity = -15;
        }
        elsif($event->key_sym == SDLK_s)    
        {
            $paddle1Velocity = 15;
        }
        
        if($event->key_sym == SDLK_UP)    
        {
            $paddle2Velocity = -15;
        }
        elsif($event->key_sym == SDLK_DOWN)    
        {
            $paddle2Velocity = 15;
        }

        if($event->key_sym == SDLK_q)
        {
            $controller->stop;
        }
    }
    elsif($event->type == SDL_KEYUP)
    {
        if($event->key_sym == SDLK_w || $event->key_sym == SDLK_s)
        {
            $paddle1Velocity = 0; 
        }
        if($event->key_sym == SDLK_UP || $event->key_sym == SDLK_DOWN)
        {
            $paddle2Velocity = 0;
        }
    }

}

sub calculate_ball
{
    my $step = shift;
    my $app = shift;
    my $t = shift;

    if($ballX >= $app->w || $ballX <= 0)
    {
        $ballX = $app->w / 2;
        $ballY = $app->h / 2;
        
        $xVelocity = -13.5;
        $yVelocity = 9;

        $xVelocity = -$xVelocity;
    }

    if(
        $ballX <= 20 && $ballX > 0 &&
        $ballY >= $paddle1 && $ballY <= $paddle1 + 150 ||
        $ballX >= $app->w - 20 && $ballX < $app->w &&
        $ballY >= $paddle2 && $ballY <= $paddle2 + 150
    )
    {
        $xVelocity = -$xVelocity;

        $xVelocity *= 1.12;
        $yVelocity *= 1.12;
    }
    $ballX += $xVelocity * $step;
    
    if($ballY >= $app->h || $ballY <= 0)
    {
        $yVelocity = -$yVelocity;
    }
    $ballY += $yVelocity * $step;
}

sub calculate_paddles
{
    my $step = shift;
    my $app = shift;
    my $t = shift;
        
    $paddle1 += $paddle1Velocity * $step;
    $paddle2 += $paddle2Velocity * $step;
}

sub render_ball
{
    my $delta = shift;
    my $app = shift;

    # background
    $app->draw_rect([0, 0, $app->w, $app->h], 0);

    # ball
    $app->draw_rect([$ballX, $ballY, 10, 10], [255, 255, 255, 255]);

    # paddles
    $app->draw_rect(
        [0, $paddle1, 20, 150], [255, 255, 255, 255]
    );
    $app->draw_rect(
        [$app->w - 20, $paddle2, 20, 150], [255, 255, 255, 255]
    );

    $app->update;
}

$app->update;
