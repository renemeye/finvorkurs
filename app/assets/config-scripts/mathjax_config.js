MathJax.Hub.Config({
 tex2jax: {
   inlineMath: [ ['$','$'] ],
   processEscapes: true
 },
 showMathMenu: true,
 menuSettings: {
 	zoom: "Hover",
 	zscale: "175%"
 },
 TeX: {
	Macros: {
		diff: '{\\rm d}',
		C: '{\\mathbb C}',
		R: '{\\mathbb R}',
		Z: '{\\mathbb Z}',
		N: '{\\mathbb N}',
		NNN: '{\\mathcal N}',
		FF: '{\\mathcal F}',
		LL: '{\\mathcal L}',
		eV: '{\\,\\,{\\rm eV}}',
		keV: '{\\,\\,{\\rm keV}}',
		MeV: '{\\,\\,{\\rm MeV}}',
		GeV: '{\\,\\,{\\rm GeV}}',
		TeV: '{\\,\\,{\\rm TeV}}',
		diag: '{\\rm diag}',
		pfrac: ['\\frac{\\partial #1}{\\partial #2}',2],
		ddfrac: ['\\frac{{\\rm d} #1}{{\\rm d} #2}',2],
		bold: ['{\\bf #1}',1],
		zav: ['\\left({#1}\\right)',1],
		eq: ['\\begin{align} #1 \\end{align}',1],
		abs: ['\\left|{#1}\\right|',1],
		braket: ['\\langle{#1}|{#2}\\rangle',2],
		bra: ['\\langle{#1}|',1],
		ket: ['{|{#1}\\rangle}',1]
	}
  }
});
