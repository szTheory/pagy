# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/bootstrap

# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_bootstrap_nav(pagy)
      link = pagy_link_proc(pagy, 'class="page-link"')

      html = pagy_bootstrap_prev(pagy, link)
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case  item
                when Integer then %(<li class="page-item">#{link.call item}</li>)
                when String  then %(<li class="page-item active">#{link.call item}</li>)
                when :gap    then %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t 'pagy.nav.gap'}</a></li>)
                end
      end
      html << pagy_bootstrap_next(pagy, link)
      %(<nav class="pagy-bootstrap-nav" role="navigation" aria-label="pager"><ul class="pagination">#{html}</ul></nav>)
    end

    # Javascript pagination for bootstrap: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_bootstrap_nav_js(pagy, id=pagy_id)
      link = pagy_link_proc(pagy, 'class="page-link"')

      tags = { 'before' => %(<ul class="pagination">#{pagy_bootstrap_prev pagy, link}),
               'link'   => %(<li class="page-item">#{mark = link.call(PAGE_PLACEHOLDER)}</li>),
               'active' => %(<li class="page-item active">#{mark}</li>),
               'gap'    => %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t 'pagy.nav.gap'}</a></li>),
               'after'  => %(#{pagy_bootstrap_next pagy, link}</ul>) }
      %(<nav id="#{id}" class="pagy-bootstrap-nav-js" role="navigation" aria-label="pager"></nav>#{pagy_json_tag pagy, :nav, id, tags, pagy.sequels })
    end

    # Javascript combo pagination for bootstrap: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_bootstrap_combo_nav_js(pagy, id=pagy_id)
      link    = pagy_link_proc(pagy)
      p_prev  = pagy.prev
      p_next  = pagy.next
      p_page  = pagy.page
      p_pages = pagy.pages

      html = %(<nav id="#{id}" class="pagy-bootstrap-combo-nav-js pagination" role="navigation" aria-label="pager"><div class="btn-group" role="group">)
      html << if p_prev
                link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous" class="prev btn btn-primary"'
              else
                %(<a class="prev btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.prev')}</a>)
              end
      input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" class="text-primary" style="padding: 0; border: none; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
      html << %(<div class="pagy-combo-input btn btn-primary disabled" style="white-space: nowrap;">#{pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages}</div>)
      html << if p_next
                link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next" class="next btn btn-primary"'
              else
                %(<a class="next btn btn-primary disabled" href="#">#{pagy_t 'pagy.nav.next' }</a>)
              end
      html << %(</div></nav>#{pagy_json_tag pagy, :combo_nav, id, p_page, pagy_marked_link(link)})
    end

    private

      def pagy_bootstrap_prev(pagy, link)
        p_prev = pagy.prev
        if p_prev
          %(<li class="page-item prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
        else
          %(<li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t 'pagy.nav.prev'}</a></li>)
        end
      end

      def pagy_bootstrap_next(pagy, link)
        p_next = pagy.next
        if p_next
          %(<li class="page-item next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
        else
          %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t 'pagy.nav.next' }</a></li>)
        end
      end

  end
end
