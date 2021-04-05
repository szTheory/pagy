# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/bulma

# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for Bulma: it returns the html with the series of links to the pages
    def pagy_bulma_nav(pagy)
      link = pagy_link_proc(pagy)
      html = pagy_bulma_prev_next(pagy, link)
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer then %(<li>#{link.call item, item, %(class="pagination-link" aria-label="goto page #{item}") }</li>)                           # page link
                when String  then %(<li>#{link.call item, item, %(class="pagination-link is-current" aria-label="page #{item}" aria-current="page")}</li>)  # active page
                when :gap    then %(<li><span class="pagination-ellipsis">#{pagy_t('pagy.nav.gap')}</span></li>)                                            # page gap
                end
      end
      html << '</ul>'
      %(<nav class="pagy-bulma-nav pagination is-centered" role="navigation" aria-label="pagination">#{html}</nav>)
    end

    # Javascript pagination for bulma: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_bulma_nav_js(pagy, id=pagy_id)
      link = pagy_link_proc(pagy)
      tags = { 'before' => pagy_bulma_prev_next(pagy, link),
               'link'   => %(<li>#{link.call PAGE_PLACEHOLDER, PAGE_PLACEHOLDER, %(class="pagination-link" aria-label="goto page #{PAGE_PLACEHOLDER}")}</li>),
               'active' => %(<li>#{link.call PAGE_PLACEHOLDER, PAGE_PLACEHOLDER, %(class="pagination-link is-current" aria-current="page" aria-label="page #{PAGE_PLACEHOLDER}")}</li>),
               'gap'    => %(<li><span class="pagination-ellipsis">#{pagy_t 'pagy.nav.gap' }</span></li>),
               'after'  => '</ul>' }
      %(<nav id="#{id}" class="pagy-bulma-nav-js pagination is-centered" role="navigation" aria-label="pagination"></nav>#{pagy_json_tag pagy, :nav, id, tags, pagy.sequels})
    end

    # Javascript combo pagination for Bulma: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_bulma_combo_nav_js(pagy, id=pagy_id)
      link    = pagy_link_proc(pagy)
      p_prev  = pagy.prev
      p_next  = pagy.next
      p_page  = pagy.page
      p_pages = pagy.pages

      html = %(<nav id="#{id}" class="pagy-bulma-combo-nav-js" role="navigation" aria-label="pagination"><div class="field is-grouped is-grouped-centered" role="group">)
      html << if p_prev
                %(<p class="control">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'class="button" aria-label="previous page"'}</p>)
              else
                %(<p class="control"><a class="button" disabled>#{pagy_t 'pagy.nav.prev'}</a></p>)
              end
      input = %(<input class="input" type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem; margin:0 0.3rem;">)
      html << %(<div class="pagy-combo-input control level is-mobile">#{pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages)}</div>)
      html << if p_next
                %(<p class="control">#{link.call p_next, pagy_t('pagy.nav.next'), 'class="button" aria-label="next page"'}</p>)
              else
                %(<p class="control"><a class="button" disabled>#{pagy_t 'pagy.nav.next'}</a></p>)
              end
      html << %(</div></nav>#{pagy_json_tag pagy, :combo_nav, id, p_page, pagy_marked_link(link)})
    end

    private

      def pagy_bulma_prev_next(pagy, link)
        p_prev = pagy.prev
        p_next = pagy.next

        html = if p_prev
                 link.call p_prev, pagy_t('pagy.nav.prev'), 'class="pagination-previous" aria-label="previous page"'
               else
                 %(<a class="pagination-previous" disabled>#{pagy_t 'pagy.nav.prev'}</a>)
               end
        html << if p_next
                  link.call p_next, pagy_t('pagy.nav.next'), 'class="pagination-next" aria-label="next page"'
                else
                  %(<a class="pagination-next" disabled>#{pagy_t 'pagy.nav.next' }</a>)
                end
        html << '<ul class="pagination-list">'
        html
      end

  end
end
