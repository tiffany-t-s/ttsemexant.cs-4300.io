@fragment 
fn fs( @builtin(position) pos : vec4f ) -> @location(0) vec4f {
	//npos is for stars, p is for gradient, p2 is for shooting stars
 	var npos = fract(sin(uvN( pos.xy )));
	let p = uvN( pos.xy);
	var p2 : vec2f = fract( uvN( pos.xy ) * 9. );

	//changes how stars move
	npos.x += sin( (seconds()  )) * .35;
    	npos.y += sin( (seconds()  )) * .15;

	//create inital black and blue for gradient
	let color1 = vec3(0.1, 0.0, 0.25); 
	let color2 = vec3(0.001, 0.001, 0.0015);

	//for the gradient 
	let t = sin(seconds()*2.2);
	let v = p.xy;

	//for dots
	let tiled = fract( npos * 35. );
    	let circles   = (distance( tiled, vec2(.7)) );
    	let threshold = 1. - smoothstep( .0005, .1, circles ); //#4 .3
	let feedback = lastframe(rotate (p, seconds())*1.35); //#5 /5
	//final outcome
	//let stars = threshold; //#2
	let stars = threshold + feedback/3; //#3

	//for the colors
	let new_col1 = mix(color2, color1, v.y);
	let new_col2 = mix(color2, color1, t);
	let new_col3 = mix(new_col2, new_col1,  v.x);
	//final outcome
	let gradient = vec4f(new_col3, 1.);


	//for shooting stars
 	p2.x += sin( (seconds()  )) * .35;
    	p2.y += cos( (seconds()  )) * .15;

    	let circles2   = distance( p2, vec2(.5) );
    	let threshold2 = 1.-smoothstep( .05,.0525, circles2 );
    	let feedback2  = lastframe( p * 1.00125 );
    	let out = threshold2 * .3 + feedback2 * .975;
	//final outcome
	let sh_stars = vec4f(out.x+threshold2, out.z, out.y+threshold2, out.w);
	//sh_stars.r += color1.r; sh_stars.b += color1.b; sh_stars.g += color1.g;

	//return vec4f(new_col2 /2., 1.); //changing colors 
	//return vec4f(stars); //just starts/dots
	//return gradient; //moving gradient 
	return gradient + stars; //stars and sky #1
	//return sh_stars; //the shooting stars #6
	//return gradient + sh_stars;
}